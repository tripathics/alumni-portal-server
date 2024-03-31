import OTP from '../models/otp.model.js';
import transporter from '../config/nodemailer.config.js';
import logger from '../config/logger.config.js';
import ApiError from './ApiError.util.js';

const MAX_ATTEMPTS = 5;

export const sendOTPEmail = async (email, otp) => {
  const emailHtml = `
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Your NIT AP Alumni account OTP</title>
<style>
* {
margin: 0;
padding: 0;
}
body {
font-family: "Arial", sans-serif;
background-color: #f2f8f8;
margin: 0;
padding: 0;
padding-top: 2rem;
}
.container {
background-color: #fff;
border: solid 1px #e1e1e1;
border-radius: 2px;
padding: 1.4rem;
max-width: 380px;
margin: auto;
}
.header {
width: fit-content;
margin: auto;
}
h1 {
font-size: 1.2rem;
font-weight: 300;
margin: 1rem 0;
font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
}
p {
font-size: 0.9rem;
color: #222;
margin: 0.8rem 0;
}
.primary {
color: #18621f;
}
.footer {
margin-top: 1rem;
font-size: 0.9rem;
}
.footer > * {
font-size: inherit;
}
</style>
</head>
<body>
<div class="container">
<header class="header">
<img
src="https://raw.githubusercontent.com/tripathics/alumni-portal-client/main/public/navbar-banner.png"
alt="NIT Arunachal Pradesh Alumni Association"
style="width: 200px; height: auto"
/>
</header>
<main>
<div style="margin: 1rem auto; width: fit-content">
<table
width="180"
border="0"
align="center"
cellpadding="0"
cellspacing="0"
>
<tbody>
<tr>
<td
bgcolor="#FFFFFF"
style="
font-size: 18px;
line-height: 22px;
font-family: 'Zurich BT', Tahoma, Helvetica, Arial;
text-align: center;
color: rgb(0, 0, 0);
border-width: 1px;
border-style: dashed;
border-color: rgb(204, 204, 204);
padding: 10px 5px;
letter-spacing: 0.15ch;
"
>
<strong>${otp}</strong>
</td>
</tr>
</tbody>
</table>
</div>
<div>
<p>
Please use the above One Time Password (OTP) for your NITAP Alumni
Association account. This OTP is valid for next 5 minutes.
</p>
<p style="font-style: italic">
For security purposes, please do not share OTP or Password with
anyone.
</p>
</div>
</main>
<footer class="footer">
<p>
Best Regards,<br />
Alumni association<br />
NIT Arunachal Pradesh
</p>
</footer>
</div>
</body>
</html>
  `;
  const mailOptions = {
    from: process.env.NODEMAILER_EMAIL,
    to: email,
    subject: `NIT AP Alumni OTP - ${otp}`,
    html: emailHtml,
  };

  try {
    await transporter.sendMail(mailOptions);
    logger.info(`OTP: ${otp} sent to ${email}`);
  } catch (error) {
    throw new ApiError(500, 'OTP', 'Error sending OTP email');
  }
};

export const generateOTP = async (email) => {
  const otp = Math.floor(Math.random() * 10e5).toString().padEnd(6, '0');

  // check if attempts less than 3 and last attempt is more than 24 hours ago
  const attempt = await OTP.findAttemptByEmail(email);
  if (attempt && attempt.attempts > MAX_ATTEMPTS) {
    // Convert otpResult.updated_at to the server's timezone
    const updatedAtLocal = new Date(attempt.updated_at);
    updatedAtLocal.setMinutes(updatedAtLocal.getMinutes() - new Date().getTimezoneOffset());
    // if last attempt is less than 24 hours ago
    if (new Date() - updatedAtLocal < 24 * 60 * 60 * 1000) {
      throw new ApiError(400, 'OTP', 'Max limit reached for today. Please try again after 24 hrs.');
    }
    // reset the attempts to 0
    await OTP.resetAttempts(email);
  }

  // store the otp in database
  await OTP.createOTP({ email, otp });
  return { email, otp };
};

export const verifyOTP = async (email, otp) => {
  const otpResult = await OTP.findOTPByEmail(email);
  if (!otpResult) {
    throw new Error('OTP: Email not found');
  }
  // check if otp is matched
  if (otpResult.otp === otp) {
    // Convert otpResult.updated_at to the server's timezone
    const updatedAtLocal = new Date(otpResult.updated_at);
    updatedAtLocal.setMinutes(updatedAtLocal.getMinutes() - new Date().getTimezoneOffset());
    // otp expired
    if (new Date() - updatedAtLocal > 5 * 60 * 1000) {
      // const otpDeleteResult = await OTP.deleteOTP(email);  // delete expired otp
      // if (!otpDeleteResult) {
      //   logger.error('OTP: Error deleting expired OTP');
      // }
      throw new ApiError(400, 'OTP', 'OTP Expired');
    }
    // OTP is correct so mark the OTP verified and reset attempts to 0
    OTP.markVerified(email);
    OTP.resetAttempts(email);
    return { success: true };
  }
  // increment the number of attempts
  const { attempts } = await OTP.incrementAttempts(email);
  if (attempts > MAX_ATTEMPTS) {
    throw new ApiError(400, 'OTP', 'Max limit reached for today. Please try again after 24 hrs.');
  }
  throw new ApiError(400, 'OTP', `Incorrect OTP. Attempts left: ${MAX_ATTEMPTS - attempts + 1}`);
};

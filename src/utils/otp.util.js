import OTP from '../models/otp.model.js';
import transporter from '../config/nodemailer.config.js';
import logger from '../config/logger.config.js';

const MAX_ATTEMPTS = 5;

export const sendOTPEmail = (email, otp) => {
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
box-shadow: rgba(0, 0, 0, 0.133) 0px 1.6px 3.6px 0px,
rgba(0, 0, 0, 0.11) 0px 0.3px 0.9px 0px;
border-radius: 2px;
padding: 1.4rem;
max-width: 380px;
margin: auto;
}
.header {
text-align: center;
}
h1 {
font-size: 1.2rem;
font-weight: 300;
margin: 1rem 0;
font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
}
p {
font-size: 1rem;
color: #333;
}
.primary {
color: #18621f;
}
main {
text-align: center;
}
.otp-box-wrapper {
height: 2.8rem;
}
.otp-box {
width: fit-content;
border: solid 1px rgba(0, 0, 0, 0.11);
box-shadow: rgba(0, 0, 0, 0.133) 0px 1.6px 3.6px 0px;
padding: 0.3rem 0.6rem;
margin: 0.4rem auto;
}
.otp {
font-family: "Courier New", Courier, monospace;
font-size: 1.2rem;
letter-spacing: 0.075rem;
}
.footer {
margin-top: 2rem;
font-size: 0.9rem;
}
.footer h4 {
margin: 1.4rem 0 0.2rem;
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
src="http://localhost:5173/navbar-banner.svg"
alt="NIT Arunachal Pradesh Alumni Association"
style="width: 200px; height: auto"
/>
</header>
<main>
<h1 class="primary">OTP for your NIT AP Alumni Account</h1>
<div>
<p>Your One Time Password is</p>
<div class="otp-box-wrapper">
<div class="otp-box">
<strong class="otp">${otp}</strong>
</div>
</div>
</div>
<p>This OTP will expire in 5 minutes</p>
</main>
<footer class="footer">
<h4>Best Regards</h4>
<p>
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

  transporter.sendMail(mailOptions, (err, info) => {
    if (err) {
      logger.error(`Error sending OTP email to ${email}: ${err.message}`);
      throw new Error('Error sending OTP email');
    }
    logger.log(`OTP ${otp} sent to ${email}: ${info}`);
  });
};

export const generateOTP = async (email) => {
  const otp = Math.floor(Math.random() * 10e5).toString().padEnd(6, '0');

  try {
    // check if attempts less than 3 and last attempt is more than 24 hours ago
    const attempt = await OTP.findAttemptByEmail(email);
    if (attempt && attempt.attempts >= MAX_ATTEMPTS) {
      // if last attempt is less than 24 hours ago
      if (new Date() - new Date(attempt.updated_at) < 24 * 60 * 60 * 1000) {
        throw new Error('OTP: Max limit reached');
      }
      // reset the attempts to 0
      await OTP.resetAttempts(email);
    }

    // store the otp in database
    await OTP.createOTP({ email, otp });
    return { email, otp };
  } catch (err) {
    if (err.message === 'OTP: Max limit reached') {
      throw err;
    }
    logger.error(`DATABASE: ${err.message}`);
    throw new Error('Error generating OTP');
  }
};

export const verifyOTP = async (email, otp) => {
  try {
    const otpResult = await OTP.findOTPByEmail(email);
    if (!otpResult) {
      throw new Error('OTP: Email not found');
    }
    // check if otp is matched
    if (otpResult.otp === otp) {
      // delete if otp expired
      if (new Date() - new Date(otpResult.updated_at) > 5 * 60 * 1000) {
        const otpDeleteResult = await OTP.deleteOTP(email);
        if (!otpDeleteResult) {
          logger.error('OTP: Error deleting expired OTP');
        }
        throw new Error('OTP: OTP Expired');
      }
      // OTP is correct so mark the OTP verified and reset attempts to 0
      OTP.markVerified(email);
      OTP.resetAttempts(email);
      return { success: true };
    }
    // increment the number of attempts
    const { attempts } = await OTP.incrementAttempts(email);
    if (attempts > MAX_ATTEMPTS) {
      throw new Error('OTP: Max limit reached for today. Please try after 24 hours.');
    }
    throw new Error(`OTP: Incorrect OTP. Attempts left: ${MAX_ATTEMPTS - attempts + 1}`);
  } catch (err) {
    if (err.message.startsWith('OTP:')) {
      throw new Error(err.message);
    }
    logger.error(err.message);
  }
};

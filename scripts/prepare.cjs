const { execSync } = require('child_process');

if (process.env.NODE_ENV !== 'production') {
  execSync('husky install', { stdio: 'inherit' });
} else {
  console.log('Skipping husky install in production');
}

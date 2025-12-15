module.exports = ({ env }) => ({
  auth: {
    apiToken: {
      salt: env('API_TOKEN_SALT'),
    },
  },
});


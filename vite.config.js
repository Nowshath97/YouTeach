// Forward /api calls to the local API server (npm run api) during development.
export default {
  server: { proxy: { '/api': `http://localhost:${process.env.API_PORT || 8787}` } },
};

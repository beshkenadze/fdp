const path = require("path");
const fastify = require("fastify")({
  logger: process.env.LOGGER || false,
});

// Plugins
fastify.register(require("fastify-compress"));
fastify.register(require("fastify-helmet"));

const fastifyCaching = require("fastify-caching");
fastify.register(
  fastifyCaching,
  { privacy: fastifyCaching.privacy.NOCACHE },
  (err) => {
    if (err) throw err;
  }
);

fastify.register(require("fastify-static"), {
  root: path.join(__dirname, "./public"),
  prefix: "/",
});

fastify.listen(3000, "0.0.0.0", (err, address) => {
  if (err) throw err;
  fastify.log.info(`server listening on ${address}`);
});

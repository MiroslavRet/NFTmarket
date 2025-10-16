/** @type {import('next').NextConfig} */
const nextConfig = {
  async rewrites() {
    return [
      {
        source: "/koios/:path*",
        destination: "https://preview.koios.rest/api/v1/:path*",
      },
      {
        source: "/blockfrost/:path*",
        destination: "https://cardano-preview.blockfrost.io/api/v0/:path*",
      },
    ];
  },
  webpack: (config, { isServer }) => {
    config.experiments = {
      ...config.experiments,
      asyncWebAssembly: true,
      topLevelAwait: true,
      layers: true,
      syncWebAssembly: true,
    };

    if (isServer) {
      config.externals = config.externals || [];
      config.externals.push({
        "@lucid-evolution/lucid": "@lucid-evolution/lucid",
        "@lucid-evolution/uplc": "@lucid-evolution/uplc",
      });
    }

    config.module.rules.push({
      test: /\.wasm$/,
      type: "asset/resource",
    });

    return config;
  },
  reactStrictMode: true,
  swcMinify: true,
};

module.exports = nextConfig;

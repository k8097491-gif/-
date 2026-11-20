FROM node:24-alpine AS build
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
COPY pnpm-workspace.yaml ./
RUN corepack enable && pnpm install --frozen-lockfile
COPY vite.config.js ./
COPY client ./client
RUN pnpm build

FROM node:24-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY package.json pnpm-lock.yaml ./
COPY pnpm-workspace.yaml ./
RUN corepack enable && pnpm install --prod --frozen-lockfile
COPY server ./server
COPY migrations ./migrations
COPY docs ./docs
COPY --from=build /app/client/dist ./client/dist
EXPOSE 3000
CMD ["node", "server/index.js"]

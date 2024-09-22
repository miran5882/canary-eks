FROM node:14-alpine
WORKDIR /app
COPY package.json .
COPY app.js .
RUN npm install
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD wget -qO- http://localhost:3000/health || exit 1
CMD ["node", "app.js"]




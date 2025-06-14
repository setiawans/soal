FROM node:22-bookworm-slim

WORKDIR /app

# this is just to get the correct libs for chromium not actually used https://github.com/Crusaders-of-Rust/corctf-2024-public-challenge-repo/blob/master/web/corctf-challenge-dev/chall/Dockerfile
RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 libx11-xcb1 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# stole this from reddit
RUN mkdir -p /etc/opt/chrome_for_testing/policies/managed
RUN echo '{ "ExtensionManifestV2Availability": 2 }' | tee -a /etc/opt/chrome_for_testing/policies/managed/ExtensionManifestV2Availability.json

RUN useradd -ms /bin/bash ctf
RUN chown -R ctf:ctf /app
USER ctf

# ENV PUPPETEER_CACHE_DIR=/app/puppeteer_cache

COPY --chown=ctf:ctf package.json package-lock.json ./
RUN npm install

COPY --chown=ctf:ctf . .

ENV PORT=3000
ENV HEADLESS=new
ENV FLAG=.;,;.{fak3_flag}

CMD ["npm", "run", "start"]

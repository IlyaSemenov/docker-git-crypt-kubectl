FROM docker:18.09-git
RUN \
	wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-git-crypt/master/sgerrand.rsa.pub && \
	wget -q https://github.com/sgerrand/alpine-pkg-git-crypt/releases/download/0.6.0-r1/git-crypt-0.6.0-r1.apk && \
	apk add --no-cache *.apk && \
	rm *.apk && \
	wget -q -O /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.14.1/bin/linux/amd64/kubectl && \
	chmod +x /usr/local/bin/kubectl

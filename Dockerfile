FROM docker:18.09-git
ENV \
	GIT_CRYPT_VER=0.6.0-r1 \
	KUBECTL_VER=1.14.1 \
	KUSTOMIZE_VER=2.0.3
RUN \
	wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-git-crypt/master/sgerrand.rsa.pub && \
	wget -q https://github.com/sgerrand/alpine-pkg-git-crypt/releases/download/${GIT_CRYPT_VER}/git-crypt-${GIT_CRYPT_VER}.apk && \
	apk add --no-cache *.apk && \
	rm *.apk && \
	wget -q -O /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VER}/bin/linux/amd64/kubectl && \
	wget -q -O /usr/local/bin/kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/v${KUSTOMIZE_VER}/kustomize_${KUSTOMIZE_VER}_linux_amd64 && \
	chmod +x /usr/local/bin/kubectl /usr/local/bin/kustomize

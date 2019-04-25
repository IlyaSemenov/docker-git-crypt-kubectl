# docker:git with git-crypt and kubectl

Docker image derived from `docker:git` with addition of:

* git-crypt
* kubectl
* kustomize

Example usage in Gitlab CI:

```yaml
stages:
  - build
  - test
  - deploy

before_script:
  - export DOCKER_NAME=acme/foo
  - export DOCKER_TAG=$(git show -s --format=%ci $CI_COMMIT_SHA | head -c 10)-$CI_COMMIT_SHORT_SHA
  - export DOCKER_IMAGE=$DOCKER_NAME:$DOCKER_TAG

build:
  stage: build
  image: docker:git
  script: docker build . -t $DOCKER_IMAGE

test:
  stage: test
  dependencies:
    - build
  image: docker:git
  script: docker run --rm $DOCKER_IMAGE docker/test.sh

deploy:
  stage: deploy
  environment:
    name: production
    url: https://foo.acme.com
  only:
    - master
    - k8s
  dependencies:
    - build
  image: ilyasemenov/docker-git-crypt-kubectl
  script:
    - echo $GIT_CRYPT_KEY | base64 -d | git crypt unlock -
    - mkdir ~/.docker
    - grep '\.dockerconfigjson' k8s/prod/secrets/docker.yaml | sed 's/.*://'| base64 -d > ~/.docker/config.json
    - docker push $DOCKER_IMAGE
    - mkdir ~/.kube
    - cp k8s/prod/secrets/kubectl.yaml ~/.kube/config
    - cd k8s/prod
    - kustomize edit set namespace foo
    - kustomize edit set image $DOCKER_IMAGE
    - |
      cat >> kustomization.yaml <<EOF
      commonLabels:
        kubectl.app: foo
      EOF
    - cat kustomization.yaml
    - kubectl apply -k . --prune -l kubectl.app=foo

```

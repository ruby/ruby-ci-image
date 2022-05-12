# ruby-ci-image

A pipeline to publish Ruby CI container images to <http://ghcr.io/ruby/ruby-ci-image>.

## Contributing

If you want to test the container images on your forked repository with your container registry, the steps are as follows. You need to set a token up to push the containers to your container registry, as the [`docker/login-action`](https://github.com/docker/login-action#github-container-registry) uses it in `.github/workflows/publish.yml`.

1. Fork this repository.
2. Add your personal access token with checking write:packages at <https://github.com/settings/tokens>, then you get the token.
3. Add the `ACCESS_TOKEN` as a value you got above, on your forked repository "your_name/ruby-ci-image" Setting - Actions - Secrets.
4. When you push a branch to your forked repository, GitHub Actions is executed.
5. Check your container registry page, <https://github.com/users/your_name/packages/container/package/ruby-ci-image>. You can pull the container images by `docker`.

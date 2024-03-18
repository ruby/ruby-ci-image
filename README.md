# ruby-ci-image

A pipeline to publish Ruby CI container images to <http://ghcr.io/ruby/ruby-ci-image>.

## Contributing

If you want to test the container images on your forked repository with your container registry, the steps are as follows. You need to set a token up to push the containers to your container registry, as the [`docker/login-action`](https://github.com/docker/login-action#github-container-registry) uses it in `.github/workflows/publish.yml`.

1. Fork this repository.
2. Add your personal access token with checking write:packages at [Tokens (classic) page](https://github.com/settings/tokens), then you get the token.
3. Add the `ACCESS_TOKEN` as a value you got above, at Setting - Security - Secrets and variables - Actions - Actions secrets and variables page - Secrets tab on your forked repository "your_name/ruby-ci-image".
4. If you want to execute GitHub Actions workflow to test the container images on push on any branches, comment out the `on.push.branches` syntax in the `publish.yml`.
5. When you push a branch to your forked repository, GitHub Actions workflow is executed.
6. Check your container registry page, <https://github.com/users/your_name/packages/container/package/ruby-ci-image>. You can pull the container images by `docker`.

# Contributing

Thanks for helping!

When contributing to this repository, please first discuss the change you wish
to make via issue, email, or any other method with the owners of this
repository before making a change.

Please note we have a [Code of Conduct](CODE_OF_CONDUCT.md), please follow it
in all your interactions with the project.

Development should be done on an independent branch -- when ready, make a pull
request to `master` as described below.

For more help on how to contribute please reference [GitHub
Help](https://help.github.com). There are many guides including howtos on
working with git.

## The Seven Rules of a Great git Commit Message
Simple guidelines for better commit messages [source](http://chris.beams.io/posts/git-commit/)

- The seven rules of a great git commit message
- Keep in mind: This has all been said before.
- Separate subject from body with a blank line
- Limit the subject line to 50 characters
- Capitalize the subject line
- Do not end the subject line with a period
- Use the imperative mood in the subject line
- Wrap the body at 72 characters
- Use the body to explain what and why vs. how

## Pull Request Process

* Verify that your branch passes all tests locally (`npm test`).

* Update README.md with details of any changes to install instructions or
  dependencies.

* For non-trivial changes, a version update maybe required. Please note this in your Pull Request so it can be discussed. A version change will require updates in the following files:

    - `package.json`
    - `bower.json`
    - `bin/bouttime-server`

* Pull Requests must pass several checks before merging. At this moment, that
  requires passing tests, adhering to the style guide, and getting code review
  approval.

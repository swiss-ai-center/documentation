# How to configure a new GitHub repository

This guide will help you in the steps to configure a new GitHub repository to
make usage of most of the GitHub features.

## Create a new repository from a template

If you are creating a new service, start by creating a new repository from a
template as mentioned in the
[How to create a new service](./how-to-create-a-new-service.md) guide.

If you are creating a new project, start by creating a new repository.

## Update the repository details

Access the repository details (you can click the cog icon in the top right
corner of the repository to get the menu) as shown in the following screenshot:

![How to configure a new GitHub repository - Details](../assets/screenshots/how-to-configure-a-new-github-repository-details-light.png#only-light){ loading=lazy }
![How to configure a new GitHub repository - Details](../assets/screenshots/how-to-configure-a-new-github-repository-details-dark.png#only-dark){ loading=lazy }

- Add a meaningful description of the repository in the **Description** field.
- Add a link to the documentation of the repository in the **Website** field as
  mentioned in the
  [How to update the documentation](./how-to-update-the-documentation.md) guide.
- Add tags to the repository in the **Topics** field.
- All the other settings can be left to their default values.

## Update the repository settings

Access the repository settings by accessing the **Settings** tab of the
repository as shown in the following screenshot:

![How to configure a new GitHub repository - Settings](../assets/screenshots/how-to-configure-a-new-github-repository-settings-light.png#only-light){ loading=lazy }
![How to configure a new GitHub repository - Settings](../assets/screenshots/how-to-configure-a-new-github-repository-settings-dark.png#only-dark){ loading=lazy }

### General

#### Features

- Disable **Wikis**.
- Disable **Projects**.

#### Pull Requests

- Disable **Merge commits**.
- Change **Allow squash merging > Default commit message** to
  **Pull request title**.
- Disable **Allow rebase merging**.
- Enable **Automatically delete head branches**.

#### Danger Zone

Change the visibility of the repository to **Private** if you want to keep the
repository private or to **Public** if you want to make it public.

### Collaborators and teams

Add teams and collaborators to the repository as needed. For most of the Swiss
AI Center projects, we recommend to add the following teams:

- [@swiss-ai-center/core-developers](https://github.com/orgs/swiss-ai-center/teams/core-developers)
  team with **Admin** access.
- [@swiss-ai-center/managers](https://github.com/orgs/swiss-ai-center/teams/managers)
  team with **Admin** access.
- [@swiss-ai-center/contributors](https://github.com/orgs/swiss-ai-center/teams/contributors)
  team with **Maintain** access.

### Branches

Add a new branch protection rule for the `main` branch with the following
settings:

- **Branch name pattern**: `main`.
- Enable **Require a pull request before merging**.
  - Enable **Require approvals** with **1** required approval.
- Enable **Restrict who can push to matching branches**.
  - Enable **Restrict pushes that create matching branches**.
    - Add the `@swiss-ai-center/core-developers` team.
- Enable **Allow force pushes**.
  - Select **Specify who can force push**.
    - Add the `@swiss-ai-center/core-developers` team.

All the other settings can be left to their default values.

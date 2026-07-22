# How to use authentication and the admin panel

This guide explains how to sign in, manage your account and use the
administrator tools in the Swiss AI Center web application.

## Sign in

1. Select **Sign in** in the top-right application toolbar.
2. Enter your email address and password in the dialog.
3. Select **Sign in**.

After a successful login, the button is replaced by your email address. The
engine statistics button remains immediately to the left of the account menu.

The **Register (soon)** text in the dialog is intentionally disabled because
self-registration is not available yet.

## Use the account menu

Select your email address to open the account menu:

- **Account** opens your profile.
- **Admin panel** opens the administration workspace. Administrator privileges
  are required to load its data or use its actions.
- **Logout** ends the browser session and returns the catalog to its public
  view.

The application refreshes the service and pipeline catalogs after login or
logout. Resources that are not available to the current audience are therefore
removed from the interface.

## Edit your name

1. Open **Account** from the account menu.
2. Select **Edit** in **Personal information**.
3. Update the first and last names.
4. Select **Save**.

Both fields are required and accept at most 100 characters. The email address,
role and user ID are read-only.

## Use the admin panel

The navigation rail groups the current administration pages into two sections.

### User management

The **Users** page lists every user with their name, email and current role. Use
the action in the last column to promote a `user` to `admin` or downgrade an
`admin` to `user`.

The interface disables role changes for the administrator who is currently
signed in.

### Engine resources

The **Pipelines** page lists every pipeline, including pipelines that are hidden
from the current public or authenticated catalog because one of their services
is restricted or unavailable. From this page, an administrator can:

- edit the pipeline name, summary and description;
- inspect its immutable slug and operational status;
- delete the pipeline after confirming the action.

Changing the slug is not supported because it is used to connect pipelines to
their tasks and routes.

The **Services** page lists every registered service. Its access-level selector
controls who can discover and execute each service:

| Access level | Audience |
| --- | --- |
| **Public** | Everyone, with or without a login. This is the default. |
| **Users** | Authenticated users and administrators. |
| **Administrators** | Administrators only. |
| **Disabled** | Nobody through the regular catalog or execution API. |

Access level is independent of operational status. For example, a public service
can be unavailable, and a running service can still be disabled for all regular
users.

Pipelines inherit the strictest practical access restriction from their steps: a
pipeline is visible and usable only when the current audience can access every
service in that pipeline.

For API details and security behavior, see
[Authentication and authorization](../reference/core-concepts/auth.md).

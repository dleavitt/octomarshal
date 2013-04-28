The team features of Github are a pain to use. Teams, Repos, and Users all exist independently of each other; there is no built-in notion of a project team or of membership in an organization. Propose a UI, layered on top of the existing team system and using the Github API, that supports these concepts.

# Features

## Repo-level Teams

- For each repo there is one team with the same name as the repo. Easy interface for adding and removing users from this team.

## Organization-level Teams

- For each organization there is a "core" team with the same name as the organization.
- MAYBE: For each organization there can also be any number of "suborganization" teams. These would be used for contractors or other users not part of the core team.

## Other

- There should be some notion of "all users under this organization." This could be taken from Github's list or just seeded from Github's list and stored by the app.
- App should be able to ingest and store metadata for users - name, email. This should be used to make identification easier.
- Everyone has push/pull permission, always.

# Pages

## Repo List

- Dropdown listing organization
- When organization is selected, list all repos for that organization.
- Should be very easy to
  - Create a "repo team" for that repo, if it does not already have one.
  - Add/remove members from the repo's team.
  - Some way to enable/disable repo notifications would be great.
  - These members should be pulled from the list of users in the organization.

## Create Repo

- Create new repos (with the usual Github options)
- Assign members to the repo team

## Log In

You log in with your Github account.


# Endpoints

- auth
- `GET /organizations`
- `GET /organizations/:id` - repos, members, local members
- `GET /repos/:id` - get repo info and team for repo if it exists
- `POST /repos/:id/team` - create a team, add the repo to the team
- `PUT /repos/:id/team/:user` - add a user to the repo, returns the team
- `DELETE /repos/:id/team/:user` - remove a user from the repo


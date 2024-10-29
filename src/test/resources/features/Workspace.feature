@Workspaces
  Feature: Projects

    Background:
      Given base url $(env.base_url_clockify)
      And header x-api-key = $(env.api_key_clockify)
      And header Content-Type = application/json
      And header Accept = */*

    @GetAllWorkspaces
    Scenario: Get all workspaces
      And endpoint v1/workspaces
      When execute method GET
      Then the status code should be 200
      * define workspaceId = $.[1].id
      * define userid = $.[1].memberships.[0].userId



@TPFinal
  Feature: Time Entry

    Background:
      Given base url $(env.base_url_clockify)
      And header x-api-key = $(env.api_key_clockify)
      And header Content-Type = application/json
      And header Accept = */*


  #a. Consultar las horas registradas.
    @GetAllTimeEntries
    Scenario: Get all time entries
      Given call Workspace.feature@GetAllWorkspaces
      And endpoint v1/workspaces/{{workspaceId}}/user/{{userid}}/time-entries
      When execute method GET
      Then the status code should be 200


  #  b. Agregar horas a un proyecto.
    @AddTimeEntry
    Scenario: Add Time Entry
      Given call Workspace.feature@GetAllWorkspaces
      And endpoint v1/workspaces/{{workspaceId}}/user/{{userid}}/time-entries
      And body jsons/bodies/addTimeEntry.json
      When execute method POST
      Then the status code should be 201
    * define timeEntryId = $.id
    * define workspaceId = $.workspaceId


    @AddTimeEntries
    Scenario Outline: Add Time Entries
      Given call Workspace.feature@GetAllWorkspaces
      And endpoint v1/workspaces/{{workspaceId}}/user/{{userid}}/time-entries
      And body jsons/bodies/addTimeEntry.json
      And set value <description> of key description in body jsons/bodies/addTimeEntry.json
      And set value <start> of key start in body jsons/bodies/addTimeEntry.json
      And set value <end> of key end in body jsons/bodies/addTimeEntry.json
      When execute method POST
      Then the status code should be 201

      Examples:
        | description    | start               | end                  |
        | Test 1         |2024-10-10T18:00:00Z | 2024-10-10T18:10:00Z |
        | Test 2         |2024-10-10T18:20:00Z | 2024-10-10T18:30:00Z |
        | Test 3         |2024-10-10T18:40:00Z | 2024-10-10T18:50:00Z |
        | Test 4         |2024-10-10T19:00:00Z | 2024-10-10T19:30:00Z |


  #  c. Editar un campo de algún registro de hora.
    @EditTimeEntry
    Scenario: Edit Time Entry
      Given call TimeEntry.feature@AddTimeEntry
      And endpoint v1/workspaces/{{workspaceId}}/time-entries/{{timeEntryId}}
      And body jsons/bodies/editTimeEntry.json
      And set value modificado of key description in body jsons/bodies/addTimeEntry.json
      When execute method PUT
      Then the status code should be 200

  #  d. Eliminar hora registrada.
    @DeleteTimeEntry
    Scenario: Delete Time Entry
      Given call TimeEntry.feature@AddTimeEntry
      And endpoint v1/workspaces/{{workspaceId}}/time-entries/{{timeEntryId}}
      When execute method DELETE
      Then the status code should be 204
@TPN8
  Feature: Projects

    Background:
      Given base url $(env.base_url_clockify)
      And header x-api-key = $(env.api_key_clockify)

    @GetAllWorkspaces @Automated
      Scenario: Get all workspaces
        And endpoint v1/workspaces
        When execute method GET
        Then the status code should be 200
      * define workspaceId = $.[0].id

##Crear un proyecto dentro del workspace exitosamente.
    @CreateNewProject @Automated
      Scenario: Successful creation of a project
        Given call TP8.feature@GetAllWorkspaces
        And endpoint v1/workspaces/{{workspaceId}}/projects
        And header Content-Type = application/json
        And header Accept = */*
        And body jsons/bodies/addProject.json
        When execute method POST
        Then the status code should be 201


    @GetAllProjects @Automated
    Scenario: Get all projects
      Given call TP8.feature@GetAllWorkspaces
      And endpoint v1/workspaces/{{workspaceId}}/projects
      When execute method GET
      Then the status code should be 200
      * define projectId = $.[0].id

##Consultar un proyecto por su identificador exitosamente.
    @FindProjectByID @Automated
    Scenario: Find project by ID
      Given call TP8.feature@GetAllProjects
      And endpoint v1/workspaces/{{workspaceId}}/projects/{{projectId}}
      When execute method GET
      Then the status code should be 200

##Editar el valor de algún campo del proyecto y validar el cambio realizado (ejercicio libre).
    @UpdateProject @Automated
    Scenario: Update a project
      Given call TP8.feature@GetAllProjects
      And endpoint v1/workspaces/{{workspaceId}}/projects/{{projectId}}
      And header Content-Type = application/json
      And header Accept = */*
      And body jsons/bodies/updateProject.json
      When execute method PUT
      Then the status code should be 200


##Endpoint /projects, casos de error:
##No Autorizado (Status Code 401)
    @ProjectUnauthorized @Automated
    Scenario: Project Unauthorized
      Given call TP8.feature@GetAllWorkspaces
      And header x-api-key = OGZmNjE1MYyYS00ZmEzLTgxNzYtMzhkNDU2ZDBjY2Iy
      And endpoint v1/workspaces/{{workspaceId}}/projects/663d6c540a3b3a2da285d02d
      When execute method GET
      Then the status code should be 401


##Proyecto no encontrado (Status Code 404)
    @ProjectNotFound @Automated
    Scenario: Project Not found
      Given call TP8.feature@GetAllProjects
      And endpoint v1/workspace/{{workspaceId}}/projects/{{projectId}}
      When execute method GET
      Then the status code should be 404


##Bad Request (Status Code 400)
    @CreateNewProjectFailed @Automated
    Scenario: Failed creation of a project
      Given call TP8.feature@GetAllWorkspaces
      And endpoint v1/workspaces/{{workspaceId}}/projects
      And header Content-Type = application/json
      And header Accept = */*
      And body jsons/bodies/addFailedProject.json
      When execute method POST
      Then the status code should be 400


##Endpoint /projects, camino feliz. Analizar si tiene parámetros obligatorios y no obligatorios, y definir pruebas para todos los casos.
    @FailedCreateProjectByName @Automated
    Scenario: Failed creation project by name null
      Given call TP8.feature@GetAllWorkspaces
      And endpoint v1/workspaces/{{workspaceId}}/projects
      And header Content-Type = application/json
      And header Accept = */*
      And body jsons/bodies/failedProjectCreationByName.json
      When execute method POST
      Then the status code should be 400
      And response should be code = 501

    @FailedCreateProjectByWrongAmount @Automated
    Scenario: Failed creation project by wrong amount
      Given call TP8.feature@GetAllWorkspaces
      And endpoint v1/workspaces/{{workspaceId}}/projects
      And header Content-Type = application/json
      And header Accept = */*
      And body jsons/bodies/incorrectAmount.json
      When execute method POST
      Then the status code should be 400
      And response should be code = 3002

    @FailedCreateProjectByWrongClient @Automated
    Scenario: Failed creation project by wrong amount
      Given call TP8.feature@GetAllWorkspaces
      And endpoint v1/workspaces/{{workspaceId}}/projects
      And header Content-Type = application/json
      And header Accept = */*
      And body jsons/bodies/addProjectWithWrongClient.json
      When execute method POST
      Then the status code should be 400
      And response should be code = 501


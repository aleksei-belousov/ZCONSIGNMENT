CLASS lhc_status DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR status RESULT result.

    METHODS activate FOR MODIFY
      IMPORTING keys FOR ACTION status~activate.

    METHODS edit FOR MODIFY
      IMPORTING keys FOR ACTION status~edit.

    METHODS resume FOR MODIFY
      IMPORTING keys FOR ACTION status~resume.

ENDCLASS.

CLASS lhc_status IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD activate.
  ENDMETHOD.

  METHOD edit.
  ENDMETHOD.

  METHOD resume.
  ENDMETHOD.

ENDCLASS.

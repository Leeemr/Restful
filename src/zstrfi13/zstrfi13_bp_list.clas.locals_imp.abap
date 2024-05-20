CLASS lhc_arlist DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF arlist_status,
        success TYPE c LENGTH 1 VALUE 'S', " Success
        deleted TYPE c LENGTH 1 VALUE 'X', " Deleted
        ready   TYPE c LENGTH 1 VALUE 'R', " Rejected
      END OF arlist_status.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR TransList RESULT result.


ENDCLASS.

CLASS lhc_arlist IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS zcl_consignment_007_test DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_consignment_007_test IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*    MODIFY ENTITIES OF zi_consignment_007 IN LOCAL MODE
*        ENTITY Consignment
*        DELETE FROM VALUE #( (
*            %tky-ConsignmentUUID    = '93191D796ADE1EDF93B4FFFB3B0A5288'
*            %tky-%is_draft          = abap_true
*        ) )
*      MAPPED   DATA(mapped)
*      FAILED   DATA(failed)
*      REPORTED DATA(reported).

    DELETE FROM zconsignment007d. " WHERE ( consignmentid = '0000000002' ).
*    DELETE FROM zconsignment007d WHERE ( consignmentuuid = '93191D796ADE1EDF93B4FFFB3B0A5288' ).
    out->write( sy-subrc ).

    COMMIT WORK.
    out->write( sy-subrc ).

    out->write( 'end.' ).

  ENDMETHOD. " if_oo_adt_classrun~main

ENDCLASS.

CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS on_product_modify FOR DETERMINE ON MODIFY IMPORTING keys FOR Item~on_product_modify.

    METHODS on_create FOR DETERMINE ON MODIFY IMPORTING keys FOR Item~on_create.

ENDCLASS. " lhc_item DEFINITION

CLASS lhc_item IMPLEMENTATION.

  METHOD on_create.

    " Read transfered instances
    READ ENTITIES OF zi_consignment_007 IN LOCAL MODE
        ENTITY Item
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(entities).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).

        IF ( <entity>-%is_draft = '00' ). " Saved
        ENDIF.
        IF ( <entity>-%is_draft = '01' ). " Draft
        ENDIF.

*       Generate and Set New Item ID
        IF ( <entity>-ItemID IS INITIAL ).

            DATA itemID TYPE zi_item_007-ItemID VALUE '0000000000'.
*            SELECT MAX( ItemID ) FROM zi_item_007 WHERE ( ConsignmentUUID = @<entity>-ConsignmentUUID ) INTO (@itemID).
            READ ENTITIES OF zi_consignment_007 IN LOCAL MODE
                ENTITY Consignment BY \_Item
                ALL FIELDS WITH VALUE #( (
                    %tky-%is_draft          = <entity>-%is_draft
                    %tky-ConsignmentUUID    = <entity>-ConsignmentUUID
                ) )
                RESULT DATA(it_item)
                FAILED DATA(failed1)
                REPORTED DATA(reported1).
            LOOP AT it_item INTO DATA(wa_item).
                IF ( itemID < wa_item-ItemID ).
                    itemID = wa_item-ItemID.
                ENDIF.
            ENDLOOP.
            itemID  = ( itemID + 1 ).

            MODIFY ENTITIES OF zi_consignment_007 IN LOCAL MODE
                ENTITY Item
                UPDATE FIELDS ( ItemID )
                WITH VALUE #( (
                    %tky    = <entity>-%tky
                    ItemID  = itemID
                ) )
                FAILED DATA(failed2)
                MAPPED DATA(mapped2)
                REPORTED DATA(reported2).

         ENDIF.

    ENDLOOP.

  ENDMETHOD. " on_create

  METHOD on_product_modify.

    DATA it_item_update TYPE TABLE FOR UPDATE zi_consignment_007\\Item.

     " Read transfered instances
    READ ENTITIES OF zi_consignment_007 IN LOCAL MODE
        ENTITY Item
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(entities).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).

        IF ( <entity>-%is_draft = '00' ). " Saved
        ENDIF.
        IF ( <entity>-%is_draft = '01' ). " Draft
        ENDIF.

        DATA(productID) = |{ <entity>-ProductID ALPHA = IN }|.
        CONDENSE productID NO-GAPS.

*       Product Name - Product Desciption ('EN')
        SELECT SINGLE ProductDescription FROM I_ProductDescription WHERE ( Product = @productID ) AND ( Language = 'E' ) INTO @DATA(productDescription).
        IF ( sy-subrc = 0 ).
            <entity>-ProductName = productDescription.
        ELSE.
            <entity>-ProductName = ''.
        ENDIF.

*       Product URL (link to Product)
        IF ( <entity>-ProductID IS NOT INITIAL ).
            <entity>-ProductURL = '/ui#Material-manage&/C_Product(Product=''' && productID && ''',DraftUUID=guid''00000000-0000-0000-0000-000000000000'',IsActiveEntity=true)'.
        ELSE.
            <entity>-ProductURL = ''.
        ENDIF.

        APPEND VALUE #(
            %tky        = <entity>-%tky
            ProductName = <entity>-ProductName
            ProductURL  = <entity>-ProductURL
         )
         TO it_item_update.

        MODIFY ENTITIES OF zi_consignment_007 IN LOCAL MODE
            ENTITY Item
            UPDATE FIELDS ( ProductName ProductURL )
            WITH it_item_update
            FAILED DATA(failed1)
            MAPPED DATA(mapped1)
            REPORTED DATA(reported1).

    ENDLOOP.

  ENDMETHOD. " on_product_modify

ENDCLASS. " lhc_item IMPLEMENTATION

CLASS lsc_zi_consignment_007 DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS. " lsc_zi_consignment_007 DEFINITION

CLASS lsc_zi_consignment_007 IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD. " save_modified

ENDCLASS. " lsc_zi_consignment_007 IMPLEMENTATION

CLASS lhc_zi_consignment_007 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION IMPORTING keys REQUEST requested_authorizations FOR Consignment RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES IMPORTING keys REQUEST requested_features FOR Consignment RESULT result.

    METHODS activate FOR MODIFY IMPORTING keys FOR ACTION Consignment~activate.

    METHODS edit FOR MODIFY IMPORTING keys FOR ACTION Consignment~edit.

    METHODS resume FOR MODIFY IMPORTING keys FOR ACTION Consignment~resume.

    METHODS on_customer_modify FOR DETERMINE ON MODIFY IMPORTING keys FOR Consignment~on_customer_modify.
    METHODS create_physical_inventory FOR MODIFY
      IMPORTING keys FOR ACTION Consignment~create_physical_inventory.

ENDCLASS. " lhc_zi_consignment_007 DEFINITION

CLASS lhc_zi_consignment_007 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD Activate.

    " Read transfered instances
    READ ENTITIES OF zi_consignment_007 IN LOCAL MODE
        ENTITY Consignment
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(entities).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).

        IF ( <entity>-%is_draft = '00' ). " Saved
        ENDIF.
        IF ( <entity>-%is_draft = '01' ). " Draft
        ENDIF.

**       Generate and Set New Consignment ID
*        IF ( <entity>-ConsignmentID IS INITIAL ).
*
*            DATA consignmentID TYPE zi_consignment_007-ConsignmentID VALUE '0000000000'.
*            SELECT MAX( ConsignmentID ) FROM zi_consignment_007 INTO (@consignmentID).
*            consignmentID  = ( consignmentID + 1 ).
*
*            MODIFY ENTITIES OF zi_consignment_007 IN LOCAL MODE
*                ENTITY Consignment
*                UPDATE FIELDS ( ConsignmentID )
*                WITH VALUE #( (
*                    %tky            = <entity>-%tky
*                    ConsignmentID   = consignmentID
*                ) )
*                FAILED DATA(ls_failed1)
*                MAPPED DATA(ls_mapped1)
*                REPORTED DATA(ls_reported1).
*
*         ENDIF.

    ENDLOOP.

  ENDMETHOD. " Activate

  METHOD Edit.
  ENDMETHOD.

  METHOD Resume.
  ENDMETHOD.

  METHOD on_customer_modify.

    DATA it_consignment_update TYPE TABLE FOR UPDATE zi_consignment_007\\Consignment.

     " Read transfered instances
    READ ENTITIES OF zi_consignment_007 IN LOCAL MODE
        ENTITY Consignment
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(entities).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).

        IF ( <entity>-%is_draft = '00' ). " Saved
        ENDIF.
        IF ( <entity>-%is_draft = '01' ). " Draft
        ENDIF.

        DATA(customerID) = |{ <entity>-CustomerID ALPHA = IN }|.

*       Customer Name
*       SELECT SINGLE CustomerName FROM I_Customer WHERE ( Customer = @customerID ) AND ( Language = 'E' ) INTO @DATA(customerName).
        SELECT SINGLE CustomerName FROM I_Customer WHERE ( Customer = @customerID ) INTO @DATA(customerName).
        IF ( sy-subrc = 0 ).
            <entity>-CustomerName = customerName.
        ELSE.
            <entity>-CustomerName = ''.
        ENDIF.

*       Customer URL (link to Customer)
        IF ( <entity>-CustomerID IS NOT INITIAL ).
            <entity>-CustomerURL = '/ui#Customer-manage&/C_BusinessPartnerCustomer(BusinessPartner=''' && customerID && ''',DraftUUID=guid''00000000-0000-0000-0000-000000000000'',IsActiveEntity=true)'.
        ELSE.
            <entity>-CustomerURL = ''.
        ENDIF.

        APPEND VALUE #(
            %tky         = <entity>-%tky
            CustomerName = <entity>-CustomerName
            CustomerURL  = <entity>-CustomerURL
         )
         TO it_consignment_update.

        MODIFY ENTITIES OF zi_consignment_007 IN LOCAL MODE
            ENTITY Consignment
            UPDATE FIELDS ( CustomerName CustomerURL )
            WITH it_consignment_update
            FAILED DATA(failed1)
            MAPPED DATA(mapped1)
            REPORTED DATA(reported1).

    ENDLOOP.

  ENDMETHOD. " on_customer_modify

  METHOD create_physical_inventory. " Create Physical Inventory

    " Read transfered instances
    READ ENTITIES OF zi_consignment_007 IN LOCAL MODE
        ENTITY Consignment
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(entities).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).

        IF ( <entity>-%is_draft = '00' ). " Saved

*            IF ( <entity>-Released = abap_true ).
**               Short format message
*                APPEND VALUE #( %key = <entity>-%key %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = 'The Price Catalog is already released.' ) ) TO reported-pricat.
*                RETURN.
*            ENDIF.

*           Items
            READ ENTITIES OF zi_consignment_007 IN LOCAL MODE
                ENTITY Consignment BY \_Item
                ALL FIELDS WITH VALUE #( (
                    %tky = <entity>-%tky
                ) )
                RESULT DATA(lt_item)
                FAILED DATA(failed2)
                REPORTED DATA(reported2).

            IF ( lt_item[] IS INITIAL ).
*               Short format message
*                APPEND VALUE #( %key = <entity>-%key %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = 'No Attachment.' ) ) TO reported-shipment.
*                RETURN.
            ENDIF.

            SORT lt_item STABLE BY ItemID.

            DATA request_body TYPE string VALUE ''.

*           Make body as an XML
            request_body = request_body && '<Consignment>' && cl_abap_char_utilities=>cr_lf.

            request_body = request_body && '<ConsignmentID>' && <entity>-ConsignmentID && '</ConsignmentID>' && cl_abap_char_utilities=>cr_lf.
            request_body = request_body && '<CustomerID>' && <entity>-CustomerID && '</CustomerID>' && cl_abap_char_utilities=>cr_lf.
            request_body = request_body && '<CustomerName>' && <entity>-CustomerName && '</CustomerName>' && cl_abap_char_utilities=>cr_lf.
            request_body = request_body && '<MessageDate>' && <entity>-MessageDate && '</MessageDate>' && cl_abap_char_utilities=>cr_lf.
            request_body = request_body && '<Status>' && <entity>-Status && '</Status>' && cl_abap_char_utilities=>cr_lf.

            DATA productID TYPE string.
            LOOP AT lt_item INTO DATA(item).
                productID      = |{ item-ProductID ALPHA = OUT }|.
                CONDENSE productID NO-GAPS.
                request_body = request_body && '<Item>' && cl_abap_char_utilities=>cr_lf.
                request_body = request_body && '<ItemID>' && item-ItemID && '</ItemID>' && cl_abap_char_utilities=>cr_lf.
                request_body = request_body && '<ProductID>' && productID && '</ProductID>' && cl_abap_char_utilities=>cr_lf.
                request_body = request_body && '<ProducName>' && item-ProductName && '</ProducName>' && cl_abap_char_utilities=>cr_lf.
                request_body = request_body && '<Quantity>' && item-Quantity && '</Quantity>' && cl_abap_char_utilities=>cr_lf.
                request_body = request_body && '<QuantityUnit>' && item-QuantityUnit && '</QuantityUnit>' && cl_abap_char_utilities=>cr_lf.
                request_body = request_body && '</Item>' && cl_abap_char_utilities=>cr_lf.
            ENDLOOP.

            request_body = request_body && '</Consignment>' && cl_abap_char_utilities=>cr_lf.

*           Do Free Style HTTP Request
            TRY.

                DATA i_url         TYPE string. " VALUE 'https://felina-hu-scpi-test-eyjk96r2.it-cpi018-rt.cfapps.eu10-003.hana.ondemand.com/http/FiegeOutboundDevCust'.
                DATA i_username    TYPE string. " VALUE 'sb-1e950f89-c676-4acd-b0dc-24e58f8aab45!b143168|it-rt-felina-hu-scpi-test-eyjk96r2!b117912'.
                DATA i_password    TYPE string. " VALUE 'cc744b1f-5237-4a7e-ab44-858fdd00fb73$3wcTQpYfe1kbmjltnA8zSDb5ogj0TpaYon4WHM-TwfE='.

                DATA(system_url) = cl_abap_context_info=>get_system_url( ).

                IF ( system_url(8) = 'my404930' ). " dev-dev
                    i_url       = 'https://felina-hu-scpi-test-eyjk96r2.it-cpi018-rt.cfapps.eu10-003.hana.ondemand.com/http/ConsignmentStockInventoryDocument'.
                    i_username  = 'sb-1e950f89-c676-4acd-b0dc-24e58f8aab45!b143168|it-rt-felina-hu-scpi-test-eyjk96r2!b117912'.
                    i_password  = 'cc744b1f-5237-4a7e-ab44-858fdd00fb73$3wcTQpYfe1kbmjltnA8zSDb5ogj0TpaYon4WHM-TwfE='.
                ENDIF.
                IF ( system_url(8) = 'my404898' ). " dev-cust
                    i_url       = 'https://felina-hu-scpi-test-eyjk96r2.it-cpi018-rt.cfapps.eu10-003.hana.ondemand.com/http/ConsignmentStockInventoryDocument'.
                    i_username  = 'sb-1e950f89-c676-4acd-b0dc-24e58f8aab45!b143168|it-rt-felina-hu-scpi-test-eyjk96r2!b117912'.
                    i_password  = 'cc744b1f-5237-4a7e-ab44-858fdd00fb73$3wcTQpYfe1kbmjltnA8zSDb5ogj0TpaYon4WHM-TwfE='.
                ENDIF.
                IF ( system_url(8) = 'my404907' ). " test
                    i_url       = 'https://felina-hu-scpi-test-eyjk96r2.it-cpi018-rt.cfapps.eu10-003.hana.ondemand.com/http/ConsignmentStockInventoryDocument'.
                    i_username  = 'sb-1e950f89-c676-4acd-b0dc-24e58f8aab45!b143168|it-rt-felina-hu-scpi-test-eyjk96r2!b117912'.
                    i_password  = 'cc744b1f-5237-4a7e-ab44-858fdd00fb73$3wcTQpYfe1kbmjltnA8zSDb5ogj0TpaYon4WHM-TwfE='.
                ENDIF.
                IF ( system_url(8) = 'my410080' ). " prod
                    i_url       = 'https://felinahuscpi.it-cpi001-rt.cfapps.eu10.hana.ondemand.com/http/ConsignmentStockInventoryDocument'.
                    i_username  = 'sb-d6f68eaf-c42b-4ab0-931d-60753301674e!b102052|it-rt-felinahuscpi!b16077'.
                    i_password  = '462ff083-e299-4fb6-a44f-3b627fd8b406$XlkjK6-n64zyzYZkjk45eANimRNA-nMD8Pe3TKppq9w='.
                ENDIF.

                DATA(http_destination) = cl_http_destination_provider=>create_by_url(
                    i_url = i_url
                ).

                DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination(
                    i_destination = http_destination
                ).

                lo_http_client->get_http_request( )->set_authorization_basic(
                    i_username = i_username
                    i_password = i_password
                ).

                lo_http_client->get_http_request( )->set_text(
                    i_text = request_body " 'Hello, CPI!'
                ).

                DATA(lo_http_response) = lo_http_client->execute(
                    i_method   = if_web_http_client=>get
                    i_timeout  = 1
                ).

*                DATA(response_body) = lo_http_response->get_text( ).
*                DATA(status)        = lo_http_response->get_status( ).
*                DATA(header_fields) = lo_http_response->get_header_fields( ).
*                DATA(header_status) = lo_http_response->get_header_field( '~status_code' ).

*                out->write( cl_abap_char_utilities=>cr_lf && status-code && cl_abap_char_utilities=>cr_lf ).
*                out->write( cl_abap_char_utilities=>cr_lf && response_body && cl_abap_char_utilities=>cr_lf ).

*                IF ( status-code = 200 ).
                    APPEND VALUE #( %key = <entity>-%key %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Sent.'  ) ) TO reported-consignment.
*                ELSE.
*                    DATA(code) = CONV string( status-code ).
*                    CONCATENATE 'Error Status Code =' code '.' INTO DATA(text) SEPARATED BY space.
*                    APPEND VALUE #( %key = <entity>-%key %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = text  ) ) TO reported-pricat.
*                    RETURN.
*                ENDIF.

            CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
              " Handle remote Exception
*              RAISE SHORTDUMP lx_remote.
                APPEND VALUE #( %key = <entity>-%key %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = 'Remote Error.' ) ) TO reported-consignment.
                RETURN.

            CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
              " Handle Exception
*              RAISE SHORTDUMP lx_gateway.
                APPEND VALUE #( %key = <entity>-%key %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = 'Gateway Error.' ) ) TO reported-consignment.
                RETURN.

            CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
              " Handle Exception
*              RAISE SHORTDUMP lx_web_http_client_error.
*               APPEND VALUE #( %key = <entity>-%key %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = 'Web HTTP Client Error.' ) ) TO reported-consignment.
*               RETURN.
                APPEND VALUE #( %key = <entity>-%key %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Process in CPI started!.'  ) ) TO reported-consignment.

            CATCH cx_http_dest_provider_error INTO DATA(lx_http_dest_provider_error).
                "handle exception
*              RAISE SHORTDUMP lx_http_dest_provider_error.
                APPEND VALUE #( %key = <entity>-%key %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = 'HTTP Dest Provider Error.' ) ) TO reported-consignment.
                RETURN.

            CATCH cx_abap_context_info_error INTO DATA(lx_abap_context_info_error).
                "handle exception
*              RAISE SHORTDUMP lx_abap_context_info_error.
                APPEND VALUE #( %key = <entity>-%key %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = 'ABAP Context Info Error.' ) ) TO reported-consignment.
                RETURN.

            ENDTRY.

*            MODIFY ENTITIES OF zi_consignment_007 IN LOCAL MODE
*                ENTITY Consignment
*                UPDATE FIELDS ( Released )
*                WITH VALUE #( (
*                    %tky        = <entity>-%tky
*                    Released    = abap_true
*                ) )
*                FAILED DATA(failed3)
*                MAPPED DATA(mapped3)
*                REPORTED DATA(reported3).

        ENDIF.

        IF ( <entity>-%is_draft = '01' ). " Draft

*           Short format message
            APPEND VALUE #( %key = <entity>-%key %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = 'Data not saved.' ) ) TO reported-consignment.
            RETURN.

        ENDIF.

    ENDLOOP.

  ENDMETHOD. " create_physical_inventory

ENDCLASS. " lhc_zi_consignment_007 IMPLEMENTATION

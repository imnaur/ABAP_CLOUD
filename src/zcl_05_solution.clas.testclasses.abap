CLASS ltcl_find_flights DEFINITION FINAL FOR TESTING
  DURATION MEDIUM
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      test_find_cargo_flight FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_find_flights IMPLEMENTATION.

  METHOD test_find_cargo_flight.


    SELECT SINGLE
  FROM /lrn/cargoflight
  FIELDS carrier_id, connection_id, flight_date, airport_from_id, airport_to_id
  WHERE maximum_load - actual_load >= 1
  INTO @DATA(lt_flight_data).

    IF sy-subrc <> 0.
      cl_abap_unit_assert=>assert_initial( 'No data in data base.' ).
    ENDIF.

    TRY.
        DATA(lo_the_carrier) = NEW lcl_carrier( i_carrier_id = lt_flight_data-carrier_id ).
        lo_the_carrier->find_cargo_flight(
          EXPORTING
            i_airport_from_id = lt_flight_data-airport_from_id
            i_airport_to_id   = lt_flight_data-airport_to_id
            i_from_date       = lt_flight_data-flight_date
            i_cargo           = 1
          IMPORTING
            e_flight          = DATA(flight)
            e_days_later      = DATA(days_later)
        ).
        cl_abap_unit_assert=>assert_equals(
          EXPORTING
            act                  = days_later
            exp                  = 0
            msg                  = 'Something went wrong!'
            level                = if_abap_unit_constant=>severity-medium

        ).
        cl_abap_unit_assert=>assert_bound(
          EXPORTING
            act              = flight
            msg              = 'Method doesn''t return a reference!'
        ).

      CATCH cx_abap_invalid_value.
        cl_abap_unit_assert=>fail( 'Not possible to do a instance from lcl_carrier!' ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.

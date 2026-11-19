CLASS zcl_d401_05_finaltask DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_d401_05_finaltask IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA(rental) = lcl_rental=>get_instance( i_rental_id    = '50001'
                                          i_rental_model = 'Vito Plus'
                                          i_price        = 500 ).


    DATA(rental_1) = lcl_rental=>get_instance( i_rental_id    = '50001'
                                          i_rental_model = 'Vito Plus'
                                          i_price        = 500 ).
    IF rental_1 = rental.
      out->write( '------------------------------------------' ).
      out->write( 'A rental with this ID already exists.' ).
      out->write( |Rental ID:    { rental_1->mv_rental_id }| ).
      out->write( |Rental model: { rental_1->mv_rental_model }| ).
      out->write( |Price:        { rental_1->mv_price }| ).
      out->write( '------------------------------------------' ).
    ELSE.
      out->write( '------------------------------------------' ).
      out->write( |Rental ID:    { rental_1->mv_rental_id }| ).
      out->write( |Rental model: { rental_1->mv_rental_model }| ).
      out->write( |Price:        { rental_1->mv_price }| ).
      out->write( '------------------------------------------' ).

    ENDIF.

    rental->create_truck( i_make = 'Volvo'    i_model = 'TGX'       i_color = 'Night blue' i_cargo = 1000 ).
    rental->create_truck( i_make = 'MAN'      i_model = 'Power 116' i_color = 'Pure black' i_cargo = 14000 ).
    rental->create_truck( i_make = 'Mercedes' i_model = 'EQ'        i_color = 'Cold grey'  i_cargo = 18000 ).
    rental->create_truck( i_make = 'Volvo'    i_model = 'TGX-350'   i_color = 'Cold white' i_cargo = 20000 ).
    rental->create_truck( i_make = 'MAN'      i_model = 'FH16'      i_color = 'Deep red'   i_cargo = 16000 ).

    rental->create_bus( i_make = 'Mercedes' i_model = 'Vito Plus' i_color = 'Deep blue'  i_seats = 12 ).
    rental->create_bus( i_make = 'Mercedes' i_model = 'Toursimo'  i_color = 'Black'      i_seats = 24 ).
    rental->create_bus( i_make = 'Ford'     i_model = 'Tourneo'   i_color = 'Cold grey'  i_seats = 7 ).
    rental->create_bus( i_make = 'Volvo'    i_model = 'Tour iV18' i_color = 'Night black' i_seats = 18 ).
    rental->create_bus( i_make = 'Ford'     i_model = 'Tourneo+'  i_color = 'White'      i_seats = 18 ).

    LOOP AT rental->vehicles INTO DATA(vehicle).
      IF vehicle IS INSTANCE OF lcl_truck.
        TRY.
            CAST lcl_truck( vehicle )->cargo_check(  ).
          CATCH zcx_d401_05_failed INTO DATA(exc_fail_1).
            out->write( '************************************************************************************' ).

            out->write( exc_fail_1->get_text(  ) ).
            out->write( '************************************************************************************' ).

        ENDTRY.
      ENDIF.

      IF vehicle IS INSTANCE OF lcl_bus.
        TRY.
            CAST lcl_bus( vehicle )->seats_check(  ).
          CATCH zcx_d401_05_failed INTO DATA(exc_fail_2).
            out->write( '******************************************************' ).

            out->write( exc_fail_2->get_text(  ) ).
            out->write( '******************************************************' ).

        ENDTRY.
      ENDIF.

      out->write( '------------------------------------------' ).
      out->write( vehicle->display_attributes( ) ) .

    ENDLOOP.

    DATA(max_cargo) = lcl_truck=>get_max_cargo( rental->vehicles ).
    IF max_cargo IS BOUND.
      out->write( '******************************************' ).
      out->write( |Max cargo is: { max_cargo->get_cargo(  ) } KG.| ).
      out->write( max_cargo->display_attributes(  ) ).
      out->write( '******************************************' ).

    ENDIF.
  ENDMETHOD.
ENDCLASS.

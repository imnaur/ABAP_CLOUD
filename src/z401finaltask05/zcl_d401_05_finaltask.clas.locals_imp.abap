*_____________________________________SuperClass_________________________________________________

CLASS lcl_vehicle DEFINITION ABSTRACT.

  PUBLIC SECTION.

    TYPES:
      ty_make  TYPE c LENGTH 15,
      ty_model TYPE c LENGTH 15,
      ty_color TYPE string.

    TYPES: BEGIN OF st_vehicle,
             make  TYPE ty_make,
             model TYPE ty_model,
             color TYPE ty_color,
           END OF st_vehicle.

    DATA mv_make TYPE ty_make READ-ONLY .
    DATA mv_model  TYPE ty_model READ-ONLY .
    DATA mv_color TYPE ty_color READ-ONLY .


    METHODS constructor
      IMPORTING
        i_make  TYPE ty_make
        i_model TYPE ty_model
        i_color TYPE ty_color.


    METHODS display_attributes
      RETURNING VALUE(r_result) TYPE string_table.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_vehicle IMPLEMENTATION.

  METHOD constructor.

    me->mv_make = i_make.
    me->mv_model = i_model.
    me->mv_color = i_color.

  ENDMETHOD.

  METHOD display_attributes.

    APPEND |Make: { mv_make }| TO r_result.
    APPEND |Model: { mv_model }| TO r_result.
    APPEND |Color: { mv_color }| TO r_result.


  ENDMETHOD.


ENDCLASS.


*_______________________________________Truck_____________________________________________________

CLASS lcl_truck DEFINITION INHERITING FROM lcl_vehicle.

  PUBLIC SECTION.

    METHODS get_cargo
      RETURNING VALUE(r_result) TYPE i.


    TYPES tt_vehicles TYPE STANDARD TABLE OF REF TO lcl_vehicle WITH EMPTY KEY.

    CLASS-METHODS get_max_cargo
      IMPORTING i_max_vehicles  TYPE tt_vehicles
      RETURNING VALUE(r_result) TYPE REF TO lcl_truck.

    METHODS display_attributes REDEFINITION.


    METHODS constructor
      IMPORTING
        i_make  TYPE lcl_vehicle=>ty_make
        i_model TYPE lcl_vehicle=>ty_model
        i_color TYPE ty_color
        i_cargo TYPE i.


    METHODS cargo_check
      RAISING zcx_d401_05_failed.
  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA mv_cargo TYPE i.



ENDCLASS.


CLASS lcl_truck IMPLEMENTATION.

  METHOD constructor.

    super->constructor( i_make = i_make i_model = i_model i_color = i_color ).

    me->mv_cargo = i_cargo.

  ENDMETHOD.


  METHOD get_cargo.
    r_result = mv_cargo.
  ENDMETHOD.



  METHOD get_max_cargo.

    DATA lv_max_cargo TYPE i.

    LOOP AT i_max_vehicles INTO DATA(max_vehicle).
      IF max_vehicle IS INSTANCE OF lcl_truck.
        DATA(truck) = CAST lcl_truck( max_vehicle ).
        IF truck->get_cargo(  ) > lv_max_cargo.
          lv_max_cargo = truck->get_cargo(  ).
          r_result = truck.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD display_attributes.

    APPEND |Type: Truck| TO r_result.
    APPEND LINES OF super->display_attributes(  ) TO r_result.
    APPEND |Cargo: { mv_cargo } KG.| TO r_result.


  ENDMETHOD.

  METHOD cargo_check.

    IF mv_cargo < 2000.
      RAISE EXCEPTION TYPE zcx_d401_05_failed
        EXPORTING
          textid   = zcx_d401_05_failed=>max_load_achieved
          mv_make  = mv_make
          mv_model = mv_model
          mv_cargo = mv_cargo.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

*________________________________________Bus______________________________________________________

CLASS lcl_bus DEFINITION INHERITING FROM lcl_vehicle.

  PUBLIC SECTION.

    METHODS display_attributes REDEFINITION.

    METHODS constructor
      IMPORTING
        i_make  TYPE ty_make
        i_model TYPE ty_model
        i_color TYPE ty_color
        i_seats TYPE i.


    METHODS seats_check
      RAISING zcx_d401_05_failed.

  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS get_seats.
    DATA mv_seats TYPE i.


ENDCLASS.

CLASS lcl_bus IMPLEMENTATION.

  METHOD constructor.

    super->constructor( i_make = i_make i_model = i_model i_color = i_color ).

    me->mv_seats = i_seats.

  ENDMETHOD.



  METHOD get_seats.

  ENDMETHOD.

  METHOD display_attributes.
    APPEND |Type: Bus| TO r_result.
    APPEND LINES OF super->display_attributes(  ) TO r_result.
    APPEND |Seats: { mv_seats }| TO r_result.


  ENDMETHOD.

  METHOD seats_check.
    IF mv_seats < 8.
      RAISE EXCEPTION TYPE zcx_d401_05_failed
        EXPORTING
          textid   = zcx_d401_05_failed=>max_seats_achieved
          mv_make  = mv_make
          mv_model = mv_model
          mv_seats = mv_seats.
    ENDIF.

  ENDMETHOD.


ENDCLASS.

*________________________________________RentalCompany____________________________________________

CLASS lcl_rental DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.

    METHODS create_truck
      IMPORTING i_make  TYPE lcl_vehicle=>ty_make
                i_model TYPE lcl_vehicle=>ty_model
                i_color TYPE lcl_vehicle=>ty_color
                i_cargo TYPE i.

    METHODS create_bus
      IMPORTING i_make  TYPE lcl_vehicle=>ty_make
                i_model TYPE lcl_vehicle=>ty_model
                i_color TYPE lcl_vehicle=>ty_color
                i_seats TYPE i.


    TYPES: ty_rental_model TYPE c LENGTH 20,
           ty_rental_id    TYPE n LENGTH 7.

    DATA mv_rental_id TYPE ty_rental_id READ-ONLY.
    DATA mv_rental_model TYPE ty_rental_model READ-ONLY.
    DATA mv_price TYPE i READ-ONLY.
    DATA vehicles TYPE STANDARD TABLE OF REF TO lcl_vehicle WITH EMPTY KEY.


    CLASS-METHODS get_instance
      IMPORTING i_rental_id     TYPE ty_rental_id
                i_rental_model  TYPE ty_rental_model
                i_price         TYPE i
      RETURNING VALUE(r_result) TYPE REF TO lcl_rental.

    METHODS constructor
      IMPORTING
        i_rental_id    TYPE ty_rental_id
        i_rental_model TYPE ty_rental_model
        i_price        TYPE i.


  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: BEGIN OF st_rental_vehicles,
             rental_id TYPE ty_rental_id,
             instance  TYPE REF TO lcl_rental,
           END OF st_rental_vehicles.

    CLASS-DATA instances TYPE HASHED TABLE OF st_rental_vehicles WITH UNIQUE KEY rental_id.

ENDCLASS.

CLASS lcl_rental IMPLEMENTATION.


  METHOD constructor.

    mv_rental_id = i_rental_id.
    mv_rental_model = i_rental_model.
    mv_price = i_price.


  ENDMETHOD.

  METHOD get_instance.

    TRY.
        r_result = instances[ rental_id =  i_rental_id ]-instance.
      CATCH cx_sy_itab_line_not_found.
        r_result = NEW #( i_rental_id = i_rental_id
                          i_rental_model = i_rental_model
                          i_price = i_price ) .
        INSERT VALUE #( rental_id = i_rental_id
                       instance = r_result ) INTO TABLE instances.
    ENDTRY.

  ENDMETHOD.

  METHOD create_truck.
    APPEND NEW lcl_truck( i_make = i_make i_model = i_model
                          i_color = i_color i_cargo = i_cargo ) TO vehicles.
  ENDMETHOD.

  METHOD create_bus.
    APPEND NEW lcl_bus( i_make = i_make i_model = i_model
                        i_color = i_color i_seats = i_seats ) TO vehicles.
  ENDMETHOD.
ENDCLASS.




















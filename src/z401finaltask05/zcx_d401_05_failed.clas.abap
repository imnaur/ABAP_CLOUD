CLASS zcx_d401_05_failed DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      ty_make  TYPE c LENGTH 15,
      ty_model TYPE c LENGTH 15,
      ty_color TYPE string,
      ty_cargo TYPE i,
      ty_seats TYPE i.

    DATA mv_make TYPE ty_make .
    DATA mv_model  TYPE ty_model .
    DATA mv_color TYPE ty_color .
    DATA mv_cargo TYPE ty_cargo .
    DATA mv_seats TYPE ty_seats .


    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    METHODS constructor
      IMPORTING
        !textid   LIKE if_t100_message=>t100key OPTIONAL
        !previous LIKE previous OPTIONAL
        mv_make   TYPE ty_make OPTIONAL
        mv_model  TYPE ty_model OPTIONAL
        mv_color  TYPE ty_color OPTIONAL
        mv_cargo  TYPE ty_cargo OPTIONAL
        mv_seats  TYPE ty_seats OPTIONAL.

    CONSTANTS:
      BEGIN OF max_load_achieved,
        msgid TYPE symsgid VALUE 'Z05_FINALTASK_MESS',
        msgno TYPE symsgno VALUE '017',
        attr1 TYPE scx_attrname VALUE 'mv_make',
        attr2 TYPE scx_attrname VALUE 'mv_model',
        attr3 TYPE scx_attrname VALUE 'mv_cargo',
        attr4 TYPE scx_attrname VALUE 'attr4',
      END OF max_load_achieved.


    CONSTANTS:
      BEGIN OF max_seats_achieved,
        msgid TYPE symsgid VALUE 'Z05_FINALTASK_MESS',
        msgno TYPE symsgno VALUE '018',
        attr1 TYPE scx_attrname VALUE 'mv_make',
        attr2 TYPE scx_attrname VALUE 'mv_model',
        attr3 TYPE scx_attrname VALUE 'mv_seats',
        attr4 TYPE scx_attrname VALUE 'attr4',
      END OF max_seats_achieved.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcx_d401_05_failed IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor(
    previous = previous
    ).
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    me->mv_make = mv_make.
    me->mv_model = mv_model.
    me->mv_cargo = mv_cargo.
    me->mv_seats = mv_seats.

  ENDMETHOD.
ENDCLASS.







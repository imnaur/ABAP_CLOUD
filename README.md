# ABAP_CLOUD
ABAP Cloud S4D 401
# ABAP Kurs: D401 (+exercises)

![ABAP](https://img.shields.io/badge/language-ABAP-0FAAFF)
![Environment](https://img.shields.io/badge/ADT-Eclipse-2C2255)
![Status](https://img.shields.io/badge/status-%20done-brightgreen)

My solutions to the exercises of the ABAP course (S4D401), written in
**ABAP Development Tools (Eclipse)**. The repository is exported from the SAP system with
[abapGit](https://abapgit.org/).

---

## Contents

| Package | Description |
|---|---|
| `ZS4D401_05` | Exercise classes (`ZCL_05`) for the whole course |
| `Z401FINALTASK05` | Final task: vehicles, rental company, factory methods, custom exception |

---

## Topics covered

### ABAP SQL and performance
| Class | Topic |
|---|---|
| `ZCL_05_PERFORMANCE` | Performance basics (Übung 4) |
| `ZCL_05_TRACE` | Tracing (Übung 5) |
| `ZCL_05_JOIN` | Joins (Übung 10) |
| `ZCL_05_ABAP_SQL`, `_2`, `_3` | ABAP SQL (Übung 11 to 13) |

### Strings and time
| Class | Topic |
|---|---|
| `ZCL_05_TIME` | Date and time (Übung 7) |
| `ZCL_05_STRING` | String processing (Übung 9) |

### Internal tables
| Class | Topic |
|---|---|
| `ZCL_05_INTERNAL_TABLE` | Internal tables (Übung 14) |
| `ZCL_05_FS` | Field symbols (Übung 15) |
| `ZCL_05_TABLES` | Table expressions and comprehensions (Übung 16) |
| `ZCL_05_SECONDKEY` | Secondary keys (Übung 17) |

### Authorization
| Class | Topic |
|---|---|
| `ZCL_05_AUTH_CHECK` | Authority checks (Übung 18) |

### Object-oriented ABAP
| Class | Topic |
|---|---|
| `ZCL_05_CLASS` | Classes and objects (Übung 19) |
| `ZCL_05_INHERITANCE` | Inheritance, redefinition, casting (Übung 20) |
| `ZCL_05_INTERFACES`, `_1` | Interfaces (Übung 21 and 22) |
| `ZCL_05_FACTORY_METH` | Factory methods (Übung 23) |
| `ZCL_05_EXCEPTION`, `ZCL_05_EXC_CLASS` | Exceptions and exception classes (Übung 24 and 25) |
| `ZCL_05_DOC` | Documentation (Übung 26) |

---

## Final task

The final task combines the topics of the course in one small application.

```
lcl_vehicle (abstract)
  ├── lcl_truck        cargo capacity, cargo_check( )
  └── lcl_bus          seats, seats_check( )

lcl_rental             factory method get_instance( ) with an instance buffer,
                       owns the list of vehicles

zcx_d401_05_failed     custom exception class with messages from a message class
zcl_d401_05_finaltask  main class (if_oo_adt_classrun)
```

What it demonstrates:

- **Inheritance and polymorphism:** one list of `REF TO lcl_vehicle` holds trucks and buses, and `display_attributes( )` is redefined in each subclass.
- **Down-cast:** `CAST` together with `IS INSTANCE OF` to find the truck with the highest cargo capacity.
- **Factory methods:** vehicles are created through `lcl_rental`, and rentals are buffered so that one ID gives one object.
- **Custom exceptions:** trucks below 2 tonnes and buses with too few seats raise `zcx_d401_05_failed` with a text from the message class `Z05_FINALTASK_MESS`.

---

## How to run

1. Install [ABAP Development Tools](https://tools.eu1.hana.ondemand.com/) for Eclipse and connect to an ABAP system.
2. Install the abapGit plugin for ADT and link the package `ZS4D401_05` to this repository.
3. Pull the repository, activate all objects, and open a class.
4. Run a class with **F9** (classes implement `if_oo_adt_classrun`, the output appears in the Console).

---

## imnaur

**Nana Imasheva**

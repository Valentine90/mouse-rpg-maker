## About
![Version](https://img.shields.io/badge/Version-%201.2-red?style=for-the-badge&logo=appveyo)
![Rpg Maker VX ACE](https://img.shields.io/badge/RPG%20MAKER-VX%20ACE-red?style=for-the-badge&logo=appveyo)
![lANG](https://img.shields.io/badge/LANG-RUBY%20(RGSS)-red?style=for-the-badge&logo=appveyo)
<p>Mouse system for the RPG Maker VX Ace.</p>

## Class Method
```
.x ⇒ Object
```
Returns the current x coordinate of the mouse cursor on the screen.
##
```
.y ⇒ Object
```
Returns the current y coordinate of the mouse cursor on the screen.
##
```
.click?(buttons) ⇒ Boolean
```
Returns if the given buttons were pressed once in the current frame.

Parameters:
| buttons               |
|-----------------------|
| Buttons to be checked. Valid values are `:left`, `:middle` and `:right` |
## 
```
.press?(buttons) ⇒ Boolean
```
Returns if the buttons provided are pressed in the current frame.

Parameters:

| buttons               |
|-----------------------|
| Buttons to be checked. Valid values are `:left`, `:middle` and `:right` |
## 
```
.double_click?(buttons) ⇒ Boolean
```
Returns if the buttons provided were pressed twice.

Parameters:

| buttons               |
|-----------------------|
| Buttons to be checked. Valid values are `:left`, `:middle` and `:right` |

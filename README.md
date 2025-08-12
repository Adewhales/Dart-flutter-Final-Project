# Final Project (INVENTORY MANAGEMENT SYSTEM)
# Sajoma Inventory Management System

A Flutter-based inventory management system for tracking inbound and outbound stock, user management, and daily operations.
A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# count creation and login functionality:
1.	Allow users to create an email and password during account creation.
2.	Store these credentials securely (e.g., using Firestore or SharedPreferences for simplicity).
3.	Validate the credentials during login
#  Login Page that:
•	Retrieves stored email and password from SharedPreferences
•	Validates user input against stored credentials
•	Displays appropriate error messages

Dashboard screen inventory system. It includes:
•	A welcome header
•	Core widgets (Start of Day, Inbound/Outbound Stock, Stock Checker etc.)
•	An Admin Settings card shown only to Super Users:
//Track user role (Super User vs. Regular User)
//Conditionally show the Admin Settings card
//Add buttons for:
//Reset password
//un reports
//dd users
//reate users with role assignment
#	User Management Page where users can navigate with the help of Buttons to navigate to:
•	 Create User
•	Reset Password
•	Assign User to Account
•	View All Users
#	Management Page where users can:
//View all items in item catalog
//Edit item name and default unit
//Delete items with confirmation
CreateUserPage and ResetPasswordPage. These pages will include:
•	Form fields for user input
•	Role selection (Super User or Regular User)
•	Basic validation
•	Storage using SharedPreferences (for simplicity)

# Stocking/stock Entries Operation
•  Ensure item name is selected from item_catalog using Autocomplete
•  Prompt user to enter a new item name if it doesn't exist
•  Automatically add new items to item_catalog with selected unit
•  Prevent submission if unit is missing for new items

Out bound Stock
•	Item names are selected from the Hive box item_catalog instead of free text
•	Dropdown is used for item selection to ensure consistency and prevent typos
•	Form validation remains intact
•	UI and logic are cleanly structured
•  End of Day Logic Using SharedPreferences to update end_of_day_enabled. We'll switch that to Firestore at the next update.
•  Password Confirmation The confirmPassword(context) function needs to validate against Firestore-stored credentials
•  Admin Tools Access We'll ensure that superuser access is validated securely and consistently.




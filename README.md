# Mini TaskHub
A simple personal task tracking app with user authentication and task management.

## Features
- User authentication (login/signup)
- Task management (add/delete/edit)
- Supabase backend

## Setup
1. Clone the repository
2. Run `flutter pub get`
3. Create a Supabase project and set up the database as described in the Supabase Setup section
4. Add your Supabase URL and anon key to `main.dart`
5. Run the app with `flutter run`

## Supabase Setup
1. Create a new project at supabase.com
2. Enable email/password authentication
3. Create the `tasks` table with RLS policies as described in the documentation

## Hot Reload vs Hot Restart
- Hot Reload: Maintains the app state and quickly updates the UI when you make changes to the code. Best for small UI changes.
- Hot Restart: Resets the app state and fully reloads the app. Needed when you change app initialization or state management logic.

## Demo Video
https://drive.google.com/drive/folders/1rXeJGPC0QdzeEJyAo03QXvuuuTwIVmYH?usp=drive_link

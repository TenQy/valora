-- Drop check constraint on professional_level so it accepts dynamic values based on professional_areas
ALTER TABLE profiles DROP CONSTRAINT IF EXISTS profiles_professional_level_check;

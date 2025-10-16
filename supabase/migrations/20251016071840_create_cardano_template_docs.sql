/*
  # Create Cardano dApp Template Documentation Storage

  1. New Tables
    - `cardano_templates`
      - `id` (uuid, primary key)
      - `name` (text) - Template name
      - `version` (text) - Template version
      - `description` (text) - Short description
      - `repository_url` (text) - GitHub URL (when available)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)
    
    - `template_documentation`
      - `id` (uuid, primary key)
      - `template_id` (uuid, foreign key to cardano_templates)
      - `doc_type` (text) - Type of documentation (README, GUIDE, REFERENCE, etc.)
      - `title` (text) - Document title
      - `content` (text) - Full markdown content
      - `file_path` (text) - Original file path
      - `created_at` (timestamp)
      - `updated_at` (timestamp)
    
  2. Security
    - Enable RLS on both tables
    - Add policies for public read access
    - Add policies for authenticated admin write access
*/

-- Create cardano_templates table
CREATE TABLE IF NOT EXISTS cardano_templates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  version text NOT NULL DEFAULT '1.0.0',
  description text NOT NULL,
  repository_url text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create template_documentation table
CREATE TABLE IF NOT EXISTS template_documentation (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id uuid REFERENCES cardano_templates(id) ON DELETE CASCADE,
  doc_type text NOT NULL,
  title text NOT NULL,
  content text NOT NULL,
  file_path text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE cardano_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE template_documentation ENABLE ROW LEVEL SECURITY;

-- Public read access for templates
CREATE POLICY "Anyone can view Cardano templates"
  ON cardano_templates
  FOR SELECT
  TO public
  USING (true);

-- Public read access for documentation
CREATE POLICY "Anyone can view template documentation"
  ON template_documentation
  FOR SELECT
  TO public
  USING (true);

-- Authenticated users can insert templates (for admins/developers)
CREATE POLICY "Authenticated users can create templates"
  ON cardano_templates
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Authenticated users can insert documentation
CREATE POLICY "Authenticated users can create documentation"
  ON template_documentation
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Authenticated users can update templates
CREATE POLICY "Authenticated users can update templates"
  ON cardano_templates
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Authenticated users can update documentation
CREATE POLICY "Authenticated users can update documentation"
  ON template_documentation
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_template_documentation_template_id 
  ON template_documentation(template_id);
CREATE INDEX IF NOT EXISTS idx_template_documentation_doc_type 
  ON template_documentation(doc_type);

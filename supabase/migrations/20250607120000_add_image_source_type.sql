-- Add support for PNG image sources
DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_type t
    JOIN pg_enum e ON t.oid = e.enumtypid
    WHERE t.typname = 'source_type'
      AND e.enumlabel = 'image'
  ) THEN
    ALTER TYPE source_type ADD VALUE 'image';
  END IF;
END $$;

-- Allow PNG uploads in the sources bucket
UPDATE storage.buckets
SET allowed_mime_types = array_cat(allowed_mime_types, ARRAY['image/png'])
WHERE id = 'sources'
  AND NOT ('image/png' = ANY (allowed_mime_types));

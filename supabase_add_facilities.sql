-- ============================================
-- 시설 사진 관리 기능 추가
-- SQL Editor에서 New query로 실행하세요
-- ============================================

-- 1) 시설 사진 테이블
CREATE TABLE facilities (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,             -- '강의실', '자습실' 등
  image_url TEXT NOT NULL,
  display_order INT DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE facilities ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public read facilities" ON facilities FOR SELECT USING (true);
CREATE POLICY "admin write facilities" ON facilities FOR ALL
  USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

-- 2) 시설 사진 업로드용 Storage 버킷
INSERT INTO storage.buckets (id, name, public)
VALUES ('facility-images', 'facility-images', true);

CREATE POLICY "admin upload facility images" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'facility-images' AND auth.role() = 'authenticated');

CREATE POLICY "admin delete facility images" ON storage.objects
  FOR DELETE USING (bucket_id = 'facility-images' AND auth.role() = 'authenticated');

-- 3) 기존 학원소개 페이지에 있던 시설 사진 이전
INSERT INTO facilities (title, image_url, display_order) VALUES
  ('강의실', './Facilities/IMG_0251.jpg', 1),
  ('자습실', './Facilities/image.png', 2),
  ('상담실', './Facilities/image (1).png', 3),
  ('로비', './Facilities/image (2).png', 4);

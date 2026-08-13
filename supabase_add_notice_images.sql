-- ============================================
-- 공지사항 이미지 업로드 기능 추가
-- SQL Editor에서 New query로 실행하세요
-- ============================================

-- 1) notices 테이블에 이미지 URL 컬럼 추가
ALTER TABLE notices ADD COLUMN image_url TEXT;

-- 2) 이미지 저장용 Storage 버킷 생성 (공개 읽기 가능)
INSERT INTO storage.buckets (id, name, public)
VALUES ('notice-images', 'notice-images', true);

-- 3) 업로드/삭제는 로그인한 관리자만 가능
CREATE POLICY "admin upload notice images" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'notice-images' AND auth.role() = 'authenticated');

CREATE POLICY "admin delete notice images" ON storage.objects
  FOR DELETE USING (bucket_id = 'notice-images' AND auth.role() = 'authenticated');

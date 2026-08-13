-- ============================================
-- 강사 관리 기능 추가
-- SQL Editor에서 New query로 실행하세요
-- ============================================

-- 1) 강사 테이블
CREATE TABLE teachers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  role TEXT NOT NULL,              -- '원장', '대표 강사' 등
  photo_url TEXT,
  career TEXT,                     -- 경력 목록 (한 줄에 한 항목, 마지막 줄이 굵게 강조되어 현재 소속으로 표시됨)
  quote TEXT,                      -- 소개 문구
  display_order INT DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE teachers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public read teachers" ON teachers FOR SELECT USING (true);
CREATE POLICY "admin write teachers" ON teachers FOR ALL
  USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

-- 2) 강사 사진 업로드용 Storage 버킷
INSERT INTO storage.buckets (id, name, public)
VALUES ('teacher-photos', 'teacher-photos', true);

CREATE POLICY "admin upload teacher photos" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'teacher-photos' AND auth.role() = 'authenticated');

CREATE POLICY "admin delete teacher photos" ON storage.objects
  FOR DELETE USING (bucket_id = 'teacher-photos' AND auth.role() = 'authenticated');

-- 3) 기존 강사 정보 이전
INSERT INTO teachers (name, role, photo_url, career, quote, display_order) VALUES
(
  '이동하',
  '원장',
  './T_profile/이동하T 프로필.jpg',
  '前) 메가스터디 재수종합반 강사
前) 대치 다원교육 강사
前) 대치 다원교육 숙명여고 마감
現) 하이엔드 대표',
  '"같은 노력도 이동하가 만들면 다릅니다."',
  1
),
(
  '최혜림',
  '대표 강사',
  './T_profile/최혜림T 프로필2.jpg',
  '前 JEET 수학 강사
前 분당 입실론 수학 강사
現 하이엔드 수학 대표 강사',
  '"시작은 달라도 믿고 따라오면 결과는 같습니다."',
  2
),
(
  '허준우',
  '대표 강사',
  './T_profile/허준우T 프로필.jpg',
  '前 수지 K수학 고등부 전임
現 하이엔드 수학 대표 강사',
  '"1등급을 향한 공부 모든 것이 달라야 합니다."',
  3
);

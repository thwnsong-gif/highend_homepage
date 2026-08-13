-- ============================================
-- 하이엔드 수학학원 관리자 페이지용 테이블 생성
-- Supabase SQL Editor에서 전체 실행
-- ============================================

-- 1) 시간표
CREATE TABLE classes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  division TEXT NOT NULL,          -- '고등부' | '중등부'
  grade TEXT NOT NULL,             -- '고1','고2','고3','중1','중2','중3'
  class_code TEXT NOT NULL,        -- 'S1','A1' 등 반 이름
  schedule_time TEXT NOT NULL,     -- '월금 6:00~10:00'
  teacher TEXT NOT NULL,           -- '허준우T'
  description TEXT,                -- 반 소개
  display_order INT DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2) 입시결과 (연도별 대학 합격 인원)
CREATE TABLE admissions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  year INT NOT NULL,               -- 2024
  university TEXT NOT NULL,        -- '서울대학교'
  headcount INT NOT NULL,          -- 2
  display_order INT DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3) 입시결과 상단 통계 (매년 서울대 배출 / SKY 누적 / 의치약 누적)
CREATE TABLE result_stats (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  stat_key TEXT UNIQUE NOT NULL,   -- 'seoul_national' | 'sky_total' | 'medical_total'
  label TEXT NOT NULL,             -- 'SKY 누적 합격'
  value TEXT NOT NULL,             -- '78+' 또는 '매년'
  display_order INT DEFAULT 0
);

-- 4) 공지사항
CREATE TABLE notices (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  is_pinned BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- 보안 설정 (RLS)
-- 공개 페이지: 누구나 조회(SELECT) 가능
-- 관리자 페이지: 로그인(인증)한 사람만 추가/수정/삭제 가능
-- ============================================

ALTER TABLE classes ENABLE ROW LEVEL SECURITY;
ALTER TABLE admissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE result_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE notices ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public read classes" ON classes FOR SELECT USING (true);
CREATE POLICY "public read admissions" ON admissions FOR SELECT USING (true);
CREATE POLICY "public read result_stats" ON result_stats FOR SELECT USING (true);
CREATE POLICY "public read notices" ON notices FOR SELECT USING (true);

CREATE POLICY "admin write classes" ON classes FOR ALL
  USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "admin write admissions" ON admissions FOR ALL
  USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "admin write result_stats" ON result_stats FOR ALL
  USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "admin write notices" ON notices FOR ALL
  USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

-- ============================================
-- 초기 통계값 (입시실적 페이지 상단 3개 숫자)
-- 나중에 관리자 페이지에서 수정 가능
-- ============================================
INSERT INTO result_stats (stat_key, label, value, display_order) VALUES
  ('seoul_national', '서울대 합격자 배출', '매년', 1),
  ('sky_total', 'SKY 누적 합격', '78+', 2),
  ('medical_total', '의대·치대·약대 합격', '32+', 3);

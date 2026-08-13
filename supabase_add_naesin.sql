-- ============================================
-- 내신결과 기능 추가
-- SQL Editor에서 New query로 실행하세요
-- ============================================

CREATE TABLE naesin_results (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  year INT NOT NULL,               -- 2024
  semester INT NOT NULL,           -- 1 또는 2
  grade TEXT NOT NULL,             -- '1등급'
  school TEXT NOT NULL,            -- '용인 OO고'
  student_name TEXT NOT NULL,      -- '송태환'
  display_order INT DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE naesin_results ENABLE ROW LEVEL SECURITY;
CREATE POLICY "public read naesin_results" ON naesin_results FOR SELECT USING (true);
CREATE POLICY "admin write naesin_results" ON naesin_results FOR ALL
  USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

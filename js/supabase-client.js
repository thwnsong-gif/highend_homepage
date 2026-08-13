// 하이엔드 수학학원 - Supabase 공용 클라이언트
// anon(publishable) key는 브라우저에 노출되어도 안전하도록 설계된 키이며, RLS 정책으로 접근을 제어합니다.
const SUPABASE_URL = 'https://ztvjpcoidknouuilhrfl.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_GG4xOIVF1HG2EUouE099Vg_5IFkUT1z';

const sb = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

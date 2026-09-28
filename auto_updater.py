from datetime import datetime
import time
import firebase_admin
from firebase_admin import credentials, firestore
import requests

# الاتصال بـ Firebase Firestore
if not firebase_admin._apps:
  cred = credentials.Certificate('serviceAccountKey.json')
  firebase_admin.initialize_app(cred)

db = firestore.client()

# إعدادات الـ API الجديد مع إدراج المفتاح الخاص بكِ
API_KEY = "04374b6383a758b54e17c44151f824bb"
HEADERS = {"x-apisports-key": API_KEY}


def fetch_and_update_matches():
  print("جاري سحب المباريات والنتائج الحية من API-Football...")

  # جلب مباريات اليوم الحالي
  today_date = datetime.now().strftime("%Y-%m-%d")
  url = f"https://v3.football.api-sports.io/fixtures?date={today_date}"

  try:
    response = requests.get(url, headers=HEADERS)
    if response.status_code == 200:
      data = response.json()
      fixtures = data.get("response", [])

      if not fixtures:
        print("لا توجد مباريات مسجلة اليوم.")
        return

      # تحديث كل مباراة في Firestore
      for match in fixtures:
        fixture_info = match.get("fixture", {})
        teams = match.get("teams", {})
        goals = match.get("goals", {})
        status_info = fixture_info.get("status", {})

        match_id = str(fixture_info.get("id"))
        status_short = status_info.get(
            "short", "NS"
        )  # NS: لم تبدأ, LIVE: جارية, FT: انتهت

        # تحديد ما إذا كانت المباراة جارية أم لا
        is_live = status_short in ["1H", "HT", "2H", "ET", "P", "LIVE"]

        match_data = {
            "teamA": teams.get("home", {}).get("name", "Team A"),
            "teamB": teams.get("away", {}).get("name", "Team B"),
            "scoreA": str(
                goals.get("home") if goals.get("home") is not None else "0"
            ),
            "scoreB": str(
                goals.get("away") if goals.get("away") is not None else "0"
            ),
            "status": (
                str(status_info.get("elapsed"))
                if is_live
                else status_short
            ),
            "isLive": is_live,
        }

        # رفع البيانات إلى Firestore
        db.collection("matches").document(match_id).set(match_data, merge=True)

      print(
          f"تم تحديث {len(fixtures)} مباراة بنجاح في Firestore عبر API-Football!"
      )
    else:
      print(
          f"تعذر الاتصال بـ API-Football، رمز الاستجابة: {response.status_code}"
      )
  except Exception as e:
    print(f"خطأ في التنفيذ: {e}")


if __name__ == "__main__":
  while True:
    fetch_and_update_matches()
    print("في انتظار التحديث القادم خلال دقيقة واحدة...")
    time.sleep(60)
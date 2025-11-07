#!/bin/bash

# 데이터베이스 복원 스크립트

# .env 파일에서 변수 읽기
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
fi

# 기본값 설정
DB_USER=${DB_USERNAME:-user}
DB_NAME=${DB_DATABASE:-stagebridge}

# 백업 파일 확인
if [ -z "$1" ]; then
  echo "❌ 사용법: $0 <백업파일.sql>"
  echo "   예: $0 backup.sql"
  exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
  echo "❌ 백업 파일을 찾을 수 없습니다: $BACKUP_FILE"
  exit 1
fi

echo "📥 데이터베이스 복원 시작..."
echo "DB: $DB_NAME"
echo "User: $DB_USER"
echo "파일: $BACKUP_FILE"
echo ""

# Docker 컨테이너 확인
if ! docker compose ps db | grep -q "Up"; then
  echo "❌ DB 컨테이너가 실행 중이 아닙니다."
  echo "   먼저 'docker compose up -d db'를 실행하세요."
  exit 1
fi

# 경고
echo "⚠️  주의: 기존 데이터가 덮어씌워질 수 있습니다!"
read -p "계속하시겠습니까? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "취소되었습니다."
  exit 1
fi

# 복원 실행
echo "복원 중..."
docker compose exec -T db psql -U "$DB_USER" -d "$DB_NAME" < "$BACKUP_FILE"

if [ $? -eq 0 ]; then
  echo "✅ 복원 완료!"
  echo ""
  echo "데이터 확인:"
  docker compose exec db psql -U "$DB_USER" -d "$DB_NAME" -c "SELECT COUNT(*) as performances FROM performances;"
  docker compose exec db psql -U "$DB_USER" -d "$DB_NAME" -c "SELECT COUNT(*) as details FROM performance_details;"
else
  echo "❌ 복원 실패!"
  exit 1
fi


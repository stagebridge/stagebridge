#!/bin/bash

# 데이터베이스 백업 스크립트

# .env 파일에서 변수 읽기
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
fi

# 기본값 설정
DB_USER=${DB_USERNAME:-user}
DB_NAME=${DB_DATABASE:-stagebridge}
BACKUP_FILE="backup_$(date +%Y%m%d_%H%M%S).sql"

echo "📦 데이터베이스 백업 시작..."
echo "DB: $DB_NAME"
echo "User: $DB_USER"
echo ""

# Docker 컨테이너 확인
if ! docker compose ps db | grep -q "Up"; then
  echo "❌ DB 컨테이너가 실행 중이 아닙니다."
  echo "   먼저 'docker compose up -d db'를 실행하세요."
  exit 1
fi

# 백업 실행
echo "백업 중..."
docker compose exec -T db pg_dump -U "$DB_USER" -d "$DB_NAME" > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
  FILE_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
  echo "✅ 백업 완료!"
  echo "   파일: $BACKUP_FILE"
  echo "   크기: $FILE_SIZE"
else
  echo "❌ 백업 실패!"
  exit 1
fi


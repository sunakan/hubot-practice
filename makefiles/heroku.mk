################################################################################
# 変数
################################################################################
DOCKER_HEROKU_IMAGE := heroku/heroku:20.build

################################################################################
# マクロ
################################################################################

################################################################################
# タスク
################################################################################
.PHONY: bash
bash: ## heroku command
	docker run --rm -it $(DOCKER_HEROKU_IMAGE) bash

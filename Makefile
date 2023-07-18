build:
	cd contracts;sozo build

test:
	cd contracts; sozo test

prep_web:
	cd web; cp .env.example .env

redeploy:
	@cd contracts; \
	WORLD_ADDR=$$(tail -n1 ../last_deployed_world); \
	sozo migrate --world $$WORLD_ADDR;


deploy:
	@cd contracts; \
	SOZO_OUT="$$(sozo migrate)"; echo "$$SOZO_OUT"; \
	WORLD_ADDR="$$(echo "$$SOZO_OUT" | grep "Successfully migrated World at address" | rev | cut -d " " -f 1 | rev)"; \
	[ -n "$$WORLD_ADDR" ] && \
		echo "$$WORLD_ADDR" > ../last_deployed_world && \
		echo "$$SOZO_OUT" > ../deployed.log; \
	WORLD_ADDR=$$(tail -n1 ../last_deployed_world);

# Broken, but needs to be there to grant players write access
grant_write:
	@cd contracts; \
	sozo auth writer 0x03ee9e18edc71a6df30ac3aca2e0b02a198fbce19b7480a63a0d71cbd76652e0 commit; \
	sozo auth writer 0x033c627a3e5213790e246a917770ce23d7e562baa5b4d2917c23b1be6d91961c commit;


# Usage: make ecs_exe s=Spawn
ecs_exe:
	@WORLD_ADDR=$$(tail -n1 ./last_deployed_world); \
	cd contracts; echo "sozo execute $(s) --world $$WORLD_ADDR -c $(c)"; \
	sozo execute $(s) --world $$WORLD_ADDR



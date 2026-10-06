include $(CURDIR)/makefile-git-crypt/include.mk.full.inc

_test/deps/install:
	@${INCLUDE_ECHO} \
	echo_info "Some install"; \
	if ! $(MAKE) install/git-crypt; then \
		exit_with_err "Cannot install deps with install/git-crypt"; \
	fi; \
	echo_info "Some post install"; \
	exit 0
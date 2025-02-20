all:
	@echo "General Makefile only for cleaning purpose, only 2 targets"
	@echo "make clean : remove temporary  working sub-directories"
	@echo "make uclean: clean, and remove results  sub-directories"


clean:
	make -C syn clean
	make -C pr clean
	make -C sim clean
	make -C sim_post_syn clean
	make -C sim_post_pr clean
	make -C backend clean

uclean:
	make -C syn uclean
	make -C pr uclean
	make -C sim uclean
	make -C sim_post_syn uclean
	make -C sim_post_pr uclean
	make -C backend uclean

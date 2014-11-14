
PREFIX:=../
DEST:=$(PREFIX)$(PROJECT)

REBAR=rebar

all:
	@$(REBAR) get-deps compile

compile:
	@$(REBAR) skip_deps=true compile

run:
	@$(REBAR) skip_deps=true compile
	./start.sh 8080

drun:
	@$(REBAR) skip_deps=true compile -Ddebug
	./start.sh 8080

edoc:
	@$(REBAR) doc

test:
	@rm -rf .eunit
	@mkdir -p .eunit
	@$(REBAR) skip_deps=true eunit

clean:
	@$(REBAR) clean

build_plt:
	@$(REBAR) build-plt

dialyzer:
	@$(REBAR) dialyze

app:
	@$(REBAR) create template=mochiwebapp dest=$(DEST) appid=$(PROJECT)
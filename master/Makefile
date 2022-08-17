CORE_SRC = holrepl.ML buildheap.ML QFRead.sig QFRead.sml QuoteFilter.sml \
           Systeml.sig Systeml.sml

MASTER_SRC = master.ML tactic.sig tactic.sml

vscore: $(patsubst %,buildcore/%,$(CORE_SRC)) $(MASTER_SRC)
	polyc -o $@ buildcore/buildheap.ML

mllex/mllex: mllex/poly-mllex.ML mllex/mllex.sml
	polyc -o $@ $<


buildcore/QuoteFilter.sml: buildcore/QuoteFilter mllex/mllex
	mllex/mllex $<

clean:
	-rm -f mllex/mllex buildcore/QuoteFilter.sml vscore



.PHONY: clean

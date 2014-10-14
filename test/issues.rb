# encoding: utf-8

require 'sy'; require 'y_nelson' and include YNelson

# =============================================================================
# FOUND ISSUES

# With
M = Place m!: 1

# This works as expected:
G = Transition domain: M, s: { M: 1 }, rate: proc { |m| m * 0.1 }
# This works too:
G = Transition domain: M, s: { M: 1 }, rate: -> m { m * 0.1 }

# This doesn't work:
G = TS M: 0, M: 1 # domain of the transition shown as empty, should be [ M ]

# This
G = TS domain: M, s: { M: 1 }, rate: -> m { m * 0.1 }
# gives confusing error message: Supplied codomain member s does not specify a valid place!
# The user is seemingly ignorant of correct #TS syntax and tries #Transition syntax on it
# with arguments :domain, :s. TS syntax takes ordered arguments to denote domain, while
# named arguments denote codomain and its stoichiometry. TS takes care of the :domain argument,
# but does not expect a codomain given in :s alias :stoichiometry named argument, and attempts
# to convert symbol :s into a place. This error is confusing

# This
G = TS domain: M, M: 1, rate: proc do |m| m * 0.1 end
# does not work, but the cause seems to be related to Ruby syntax itself.
# This already works (replacing do / end by { / })
G = TS domain: M, M: 1, rate: proc { |m| m * 0.1 }

# This still works as expected
G = TS M, M: 1, rate: proc { |m| m * 0.1 }

# And this works, too
G = TS M, M: 1 do |m| m * 0.1 end

# This simple Boolean place definition causes problems, because the construction of a new
# simulation, when constructing a marking vecto, in #zero class method uses multplication by
# zero to get zero marking. In the future, the simulation has to admit that not all the places
# markings must support mathematical oprations.
Ck_license = Place m!: false

# Issue: NaN and surely also positive and negative float infinity will be a problem.

# Issue: constructor such as this one
T = TS A: 0, B: -1
# considers A to be a part of the codomain, when the user actually means domain.
# For now, the users will have to avoid constructs with zero stoichiometry coefficient.
# In the future, this should be corrected.

# Issue: A bit unrelated, but annoying
@w = YPetri::World.new
@net = @w.Net.send :new
@net << @w.Place.send( :new, ɴ: :A )
@net << @w.Place.send( :new, ɴ: :B )
# TS transitions A2B, A_plus
@net << @w.Transition.send( :new, ɴ: :A2B, s: { A: -1, B: 1 }, rate: 0.01 )
@net << @w.Transition.send( :new, ɴ: :A_plus, s: { A: 1 }, rate: 0.001 )

# Now this is a common mistake that the people will make. They will write:
@net.State.Feature.Marking( [ :A, :B ] )
# instead of:
@net.State.Features.Marking( [ :A, :B ] )
# The problem is that the error message of the first form is not sufficiently informative:
# No instance [:A, :B] in #<Class:0xb87c366c>

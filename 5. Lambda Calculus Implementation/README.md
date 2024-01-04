Task:

Lambda calculus β rule:

Lambda terms as discussed in the class are defined by the following grammar:

t::=x∣(λx.t)∣(tt)

Evaluation rule (called β rule) is defined as follows

(λx.t)r → t {x ↦ r}

Bellow is given types for lambda terms:

type 'a lambda = Var of 'a | Fun of 'a \* 'a lambda | App of 'a lambda \* 'a lambda

Implement the beta rule of lambda calculus.

Hint: In the implementation you have to take care variable renaming to avoid variable capture (No free variable should get bound after reduction!)

For example:

(λx.xx)y reduces with the β rule toyy

(λx.λy.x)yz reduces with the β rule to (λy′.y)z and not (λy.y)z

If you implement outermost strategy (lazy evaluation) a term (λx.(λy.xy)z)l reduces by the β rule to (λy.ly)z. If you implement innermost strategy (eager evaluation) the same term (λx.(λy.xy)z)l reduces to (λx.xz)l

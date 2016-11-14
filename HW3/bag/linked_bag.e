class
	LINKED_BAG [G->COMPARABLE] -- Complete if necessary


feature -- Access

	sorted_bags:LINKED_BAG
		-- ordered current linked_bag
		do
			
		end

	occurrences (v: G): INTEGER
			-- Number of occurrences of `v'.
		local
			c: BAG_CELL [G]
		do
			from
				c := first
			until
				c = Void or else c.value = v
			loop
				c := c.next
			end
			if c /= Void then
				Result := c.count
			end
		ensure
			non_negative_result: Result >= 0
		end

	link_on_v (v: G): BAG_CELL [G]
		local
			c: BAG_CELL [G]
		do
			from
				c := first
			until
				c = Void or else c.value = v
			loop
				c := c.next
			end
			Result := c
		end

	link_on_prev_v(v:G):BAG_CELL[G]
		local
			c:BAG_CELL[G]
		do
			from
				c := first
			until
				c = Void or else c.next.value = v
			loop
				c := c.next
			end
			Result := c
		end

	min:G
	--The minimum element from the bag
	local c,c1:BAG_CELL[G]
	do
		c:=current.first
		from
			c1 := first.next
		until
			c1 = Void
		loop
			if c1.is_less(c) then
			c:=c1
			end
			c1 := c1.next
		end
		Result:=c.value
	end
	max:G
	local c,c1:BAG_CELL[G]
	do
		c:=current.first
		from
			c1 := first.next
		until
			c1 = Void
		loop
			if c.is_less(c1) then
			c:=c1
			end
			c1 := c1.next
		end
		Result:=c.value
	end


feature -- Element change

	add (v: G; n: INTEGER)
			-- Add `n' copies of `v'.

		require
			n_positive: n > 0
		local
			c: BAG_CELL [G]
		do
			if current.occurrences (v) = 0 then
				create c.make (v)
				c.set_count (n)
				c.set_next (Void)
				if current.last = Void then
					first := c
					last := c
				else
					last.set_next (c)
					last := c
				end
			else
				c := current.link_on_v (v)
				c.set_count (c.count + n)
			end
		ensure
			n_more: occurrences (v) = old occurrences (v) + n
			first_not_void: first /= void
			last_not_void: last /= void
		end

	remove (v: G; n: INTEGER)
			-- Remove as many copies of `v' as possible, up to `n'.
		require
			n_positive: n > 0
		do

			if current.occurrences (v)/=0 then
				if current.occurrences(v)>n then
					current.link_on_v (v).set_count (current.link_on_v (v).count-n)
				else
					if current.link_on_v (v)=current.first then
						first:=current.link_on_v (v).next
					elseif current.link_on_v (v)=current.last then
						last:=current.link_on_prev_v (v)
						current.last.set_next(void)
					else
						current.link_on_prev_v (v).set_next (current.link_on_v (v).next)
					end

				end

			end

		ensure
			n_less: occurrences (v) = (old occurrences (v) - n).max (0)
		end

	subtract (other: LINKED_BAG [G])
			-- Remove all elements of `other'.
		require
			other_exists: other /= Void
		local c_other:BAG_CELL[G]
		do

			from
				c_other := other.first
			until
				c_other = Void
			loop
				current.remove(c_other.value,c_other.count)
				c_other := c_other.next
			end

		end


feature {LINKED_BAG} -- Implementation

	first: BAG_CELL [G]
			-- First cell.

	last: BAG_CELL [G]
			-- Last cell

end

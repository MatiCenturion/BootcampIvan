package com.example.primerapp.superheroapp

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.example.primerapp.R

class SuperheroAdapter(
    var superherolist: List<SuperheroItemResponse> = emptyList(),
                       private val onItemSelected:(String) -> Unit
) :
        RecyclerView.Adapter<SuperheroViewHolder>() {

    fun updateList(list: List<SuperheroItemResponse>){
        superherolist = list
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SuperheroViewHolder {
        return SuperheroViewHolder(
            LayoutInflater.from(
                parent.context).inflate(R.layout.item_superhero,parent,false)
        )
    }

    override fun onBindViewHolder(viewholder: SuperheroViewHolder, position: Int) {
        viewholder.bind(superherolist[position], onItemSelected)
    }

    override fun getItemCount() = superherolist.size

}
